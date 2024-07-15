/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:flauncher/models/app.dart';
import 'package:flauncher/models/category.dart';

part 'database.drift.dart';

@UseRowClass(App)
class Apps extends Table
{
  TextColumn get packageName => text()();

  TextColumn get name => text()();

  TextColumn get version => text()();

  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  BoolColumn get sideloaded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {packageName};
}

@UseRowClass(Category)
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get sort => intEnum<CategorySort>().withDefault(Constant(Category.Sort.index))();

  IntColumn get type => intEnum<CategoryType>().withDefault(Constant(Category.Type.index))();

  IntColumn get rowHeight => integer().withDefault(const Constant(Category.RowHeight))();

  IntColumn get columnsCount => integer().withDefault(const Constant(Category.ColumnsCount))();

  IntColumn get order => integer()();
}

@DataClassName("AppCategory")
class AppsCategories extends Table {
  IntColumn get categoryId => integer().customConstraint("REFERENCES categories(id) ON DELETE CASCADE")();

  TextColumn get appPackageName => text().customConstraint("REFERENCES apps(package_name) ON DELETE CASCADE")();

  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {categoryId, appPackageName};
}

enum CategorySort {
  manual,
  alphabetical,
}

enum CategoryType {
  row,
  grid,
}

@DriftDatabase(tables: [Apps, Categories, AppsCategories])
class FLauncherDatabase extends _$FLauncherDatabase {
  late final bool wasCreated;

  FLauncherDatabase(DatabaseConnection super.databaseConnection);

  FLauncherDatabase.inMemory() : super(LazyDatabase(() => NativeDatabase.memory()));

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from <= 1) {
            await migrator.alterTable(TableMigration(apps, newColumns: [apps.hidden, apps.sideloaded]));
          }
          if (from <= 2 && from != 1) {
            await migrator.addColumn(apps, apps.hidden);
          }
          if (from <= 3) {
            await migrator.addColumn(categories, categories.sort);
            await migrator.addColumn(categories, categories.type);
            await migrator.addColumn(categories, categories.rowHeight);
            await migrator.addColumn(categories, categories.columnsCount);
            await (update(categories)..where((tbl) => tbl.name.equals("Applications")))
                .write(const CategoriesCompanion(type: Value(CategoryType.grid)));
          }
          if (from <= 4 && from != 1) {
            await migrator.addColumn(apps, apps.sideloaded);
          }
          if (from < 6) {
            await customStatement("ALTER TABLE apps DROP COLUMN banner;");
            await customStatement("ALTER TABLE apps DROP COLUMN icon;");
          }
        },
        beforeOpen: (openingDetails) async {
          await customStatement('PRAGMA foreign_keys = ON;');
          await customStatement('PRAGMA journal_mode = WAL;');
          wasCreated = openingDetails.wasCreated;
        },
      );

  Future<List<App>> listApplications() =>
      (select(apps)..orderBy([(expr) => OrderingTerm.asc(expr.name.lower())])).get();

  Future<void> persistApps(Iterable<AppsCompanion> applications) =>
      batch((batch) => batch.insertAllOnConflictUpdate(apps, applications));

  Future<void> updateApp(String packageName, AppsCompanion value) =>
      (update(apps)..where((tbl) => tbl.packageName.equals(packageName))).write(value);

  Future<void> deleteApps(List<String> packageNames) =>
      (delete(apps)..where((tbl) => tbl.packageName.isIn(packageNames))).go();

  Future<int> insertCategory(Insertable<Category> category) => into(categories).insert(category);

  Future<void> deleteCategory(int id) => (delete(categories)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateCategories(List<CategoriesCompanion> values) => batch(
        (batch) {
          for (final value in values) {
            batch.update<$CategoriesTable, Category>(
              categories,
              value,
              where: (table) => (table.id.equals(value.id.value)),
            );
          }
        },
      );

  Future<void> updateCategory(int id, CategoriesCompanion value) =>
      (update(categories)..where((tbl) => tbl.id.equals(id))).write(value);

  Future<void> deleteAppCategory(int categoryId, String packageName) => (delete(appsCategories)
        ..where((tbl) => tbl.categoryId.equals(categoryId) & tbl.appPackageName.equals(packageName)))
      .go();

  Future<void> insertAppsCategories(List<AppsCategoriesCompanion> value) =>
      batch((batch) => batch.insertAll(appsCategories, value, mode: InsertMode.insertOrIgnore));

  Future<void> replaceAppsCategories(List<AppsCategoriesCompanion> value) =>
      batch((batch) => batch.replaceAll(appsCategories, value));

  Future<List<Category>> getCategories() {
    final query = select(categories);
    query.orderBy([ (c) => OrderingTerm.asc(c.id) ]);

    return query.get();
  }

  Future<List<AppCategory>> getAppsCategories() {
    final query = select(appsCategories);
    query.orderBy([ (c) => OrderingTerm.asc(c.appPackageName) ]);

    return query.get();
  }

  Future<List<App>> getApplications() {
    final query = select(apps);
    query.orderBy([ (a) => OrderingTerm.asc(a.name.upper()) ]);

    return query.get();
  }

  Future<List<CategoryWithApps>> listCategoriesWithVisibleApps() async {
    final query = select(categories).join([
      leftOuterJoin(appsCategories, appsCategories.categoryId.equalsExp(categories.id)),
      leftOuterJoin(apps, apps.packageName.equalsExp(appsCategories.appPackageName) & apps.hidden.equals(false)),
    ]);
    query.orderBy([
      OrderingTerm.asc(categories.order),
      OrderingTerm.asc(
        categories.sort.caseMatch(
          when: {const Constant(0): appsCategories.order, const Constant(1): apps.name.lower()},
        ),
      ),
    ]);

    final result = await query.get();
    final Map<Category, List<App>> categoriesToApps = {};
    for (final row in result) {
      final category = row.readTable(categories);
      final app = row.readTableOrNull(apps);
      final categoryToApps = categoriesToApps.putIfAbsent(category, () => []);
      if (app != null) {
        categoryToApps.add(app);
      }
    }
    return categoriesToApps.entries.map((entry) => CategoryWithApps(entry.key, entry.value)).toList();
  }

  Future<int?> nextAppCategoryOrder(int categoryId) async {
    final query = selectOnly(appsCategories);
    final maxExpression = coalesce([appsCategories.order.max(), const Constant(-1)]) + const Constant(1);
    query.addColumns([maxExpression]);
    query.where(appsCategories.categoryId.equals(categoryId));
    final result = await query.getSingle();
    return result.read(maxExpression);
  }
}

DatabaseConnection connect() => DatabaseConnection.delayed(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return DatabaseConnection(NativeDatabase(file, logStatements: foundation.kDebugMode));
    }());
