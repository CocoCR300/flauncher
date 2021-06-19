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

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'database.moor.dart';

class Apps extends Table {
  TextColumn get packageName => text()();

  TextColumn get name => text()();

  TextColumn get className => text()();

  TextColumn get version => text()();

  BlobColumn get banner => blob().nullable()();

  BlobColumn get icon => blob().nullable()();

  @override
  Set<Column> get primaryKey => {packageName};
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

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

@UseMoor(tables: [Apps, Categories, AppsCategories])
class FLauncherDatabase extends _$FLauncherDatabase {
  FLauncherDatabase([DatabaseOpener databaseOpener = _openConnection]) : super(LazyDatabase(databaseOpener));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(beforeOpen: (_) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      }, onCreate: (migrator) async {
        await migrator.createAll();
        await insertCategory(CategoriesCompanion.insert(name: "Favorites", order: 0));
        await insertCategory(CategoriesCompanion.insert(name: "Applications", order: 1));
      });

  Future<List<App>> listApplications() => select(apps).get();

  Future<void> persistApps(List<AppsCompanion> applications) =>
      batch((batch) => batch.insertAllOnConflictUpdate(apps, applications));

  Future<void> deleteApps(List<String> packageNames) =>
      (delete(apps)..where((tbl) => tbl.packageName.isIn(packageNames))).go();

  Future<Category> getCategory(String name) => (select(categories)..where((tbl) => tbl.name.equals(name))).getSingle();

  Future<void> insertCategory(CategoriesCompanion category) => into(categories).insert(category);

  Future<void> deleteCategory(int id) => (delete(categories)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> persistCategories(List<CategoriesCompanion> value) =>
      batch((batch) => batch.insertAllOnConflictUpdate(categories, value));

  Future<void> insertAppCategory(AppsCategoriesCompanion appCategory) => into(appsCategories).insert(appCategory);

  Future<void> deleteAppCategory(int categoryId, String packageName) => (delete(appsCategories)
        ..where((tbl) => tbl.categoryId.equals(categoryId) & tbl.appPackageName.equals(packageName)))
      .go();

  Future<void> persistAppsCategories(List<AppsCategoriesCompanion> value) =>
      batch((batch) => batch.insertAllOnConflictUpdate(appsCategories, value));

  Future<List<CategoryWithApps>> listCategoriesWithApps() async {
    final query = select(categories).join([
      leftOuterJoin(appsCategories, appsCategories.categoryId.equalsExp(categories.id)),
      leftOuterJoin(apps, apps.packageName.equalsExp(appsCategories.appPackageName)),
    ]);
    query.orderBy([OrderingTerm.asc(categories.order), OrderingTerm.asc(appsCategories.order)]);

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

  Future<int> nextAppCategoryOrder(int categoryId) async {
    final query = selectOnly(appsCategories);
    var maxExpression = coalesce([appsCategories.order.max(), Constant(-1)]) + Constant(1);
    query.addColumns([maxExpression]);
    query.where(appsCategories.categoryId.equals(categoryId));
    final result = await query.getSingle();
    return result.read(maxExpression);
  }
}

Future<VmDatabase> _openConnection() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(path.join(dbFolder.path, 'db.sqlite'));
  return VmDatabase(file, logStatements: true);
}
