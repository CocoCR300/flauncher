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

import 'package:flutter/foundation.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:moor_inspector/moor_inspector.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'database.moor.dart';

class Apps extends Table {
  TextColumn get packageName => text()();

  TextColumn get name => text()();

  TextColumn get version => text()();

  BlobColumn get banner => blob().nullable()();

  BlobColumn get icon => blob().nullable()();

  BoolColumn get hidden => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {packageName};
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get sort => intEnum<CategorySort>().withDefault(Constant(0))();

  IntColumn get type => intEnum<CategoryType>().withDefault(Constant(0))();

  IntColumn get rowHeight => integer().withDefault(Constant(110))();

  IntColumn get columnsCount => integer().withDefault(Constant(6))();

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

class CategoryWithApps {
  final Category category;
  final List<App> applications;

  CategoryWithApps(this.category, this.applications);
}

enum CategorySort {
  manual,
  alphabetical,
}

enum CategoryType {
  row,
  grid,
}

@UseMoor(tables: [Apps, Categories, AppsCategories])
class FLauncherDatabase extends _$FLauncherDatabase {
  FLauncherDatabase([DatabaseOpener databaseOpener = _openConnection]) : super(LazyDatabase(databaseOpener)) {
    if (kDebugMode && !Platform.environment.containsKey('FLUTTER_TEST')) {
      MoorInspectorBuilder()
        ..bundleId = 'me.efesser.flauncher'
        ..addDatabase('FLauncher', this)
        ..build().start();
    }
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from <= 3) {
            await migrator.alterTable(TableMigration(apps, newColumns: [apps.hidden]));
            await migrator.addColumn(categories, categories.sort);
            await migrator.addColumn(categories, categories.type);
            await migrator.addColumn(categories, categories.rowHeight);
            await migrator.addColumn(categories, categories.columnsCount);
            await (update(categories)..where((tbl) => tbl.name.equals("Applications")))
                .write(CategoriesCompanion(type: Value(CategoryType.grid)));
          }
        },
        beforeOpen: (openingDetails) async {
          await customStatement('PRAGMA foreign_keys = ON;');
          if (openingDetails.wasCreated) {
            await insertCategory(CategoriesCompanion.insert(name: "Favorites", order: 0));
            await insertCategory(
              CategoriesCompanion.insert(
                name: "Applications",
                order: 1,
                type: Value(CategoryType.grid),
              ),
            );
          }
        },
      );

  Future<List<App>> listApplications() => select(apps).get();

  Future<void> persistApps(List<AppsCompanion> applications) =>
      batch((batch) => batch.insertAllOnConflictUpdate(apps, applications));

  Future<void> updateApp(String packageName, AppsCompanion value) =>
      (update(apps)..where((tbl) => tbl.packageName.equals(packageName))).write(value);

  Future<void> deleteApps(List<String> packageNames) =>
      (delete(apps)..where((tbl) => tbl.packageName.isIn(packageNames))).go();

  Future<Category> getCategory(String name) => (select(categories)..where((tbl) => tbl.name.equals(name))).getSingle();

  Future<void> insertCategory(CategoriesCompanion category) => into(categories).insert(category);

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
      batch((batch) => batch.insertAll(appsCategories, value));

  Future<void> replaceAppsCategories(List<AppsCategoriesCompanion> value) =>
      batch((batch) => batch.replaceAll(appsCategories, value));

  Future<List<CategoryWithApps>> listCategoriesWithVisibleApps() async {
    final query = select(categories).join([
      leftOuterJoin(appsCategories, appsCategories.categoryId.equalsExp(categories.id)),
      leftOuterJoin(apps, apps.packageName.equalsExp(appsCategories.appPackageName) & apps.hidden.equals(false)),
    ]);
    query.orderBy([
      OrderingTerm.asc(categories.order),
      OrderingTerm.asc(
        categories.sort.caseMatch(
          when: {Constant(0): appsCategories.order, Constant(1): apps.name.lower()},
        ),
      ),
    ]);

    final result = await query.get();
    final categoriesToApps = <Category, List<App>>{};
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

  Future<List<App>> listCategoryApps(int categoryId) async {
    final query = select(appsCategories).join([
      innerJoin(apps, apps.packageName.equalsExp(appsCategories.appPackageName)),
    ]);
    query.where(appsCategories.categoryId.equals(categoryId));
    query.orderBy([OrderingTerm.asc(appsCategories.order)]);

    final result = await query.get();
    return result.map((e) => e.readTable(apps)).toList();
  }

  Future<int> nextAppCategoryOrder(int categoryId) async {
    final query = selectOnly(appsCategories);
    final maxExpression = coalesce([appsCategories.order.max(), Constant(-1)]) + Constant(1);
    query.addColumns([maxExpression]);
    query.where(appsCategories.categoryId.equals(categoryId));
    final result = await query.getSingle();
    return result.read(maxExpression);
  }

  Future<List<App>> listHiddenApplications() => (select(apps)..where((tbl) => tbl.hidden.equals(true))).get();
}

Future<VmDatabase> _openConnection() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(path.join(dbFolder.path, 'db.sqlite'));
  return VmDatabase(file, logStatements: kDebugMode);
}
