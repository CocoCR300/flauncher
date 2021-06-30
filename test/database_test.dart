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

import 'package:flauncher/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;

void main() {
  late FLauncherDatabase database;
  setUp(() {
    database = FLauncherDatabase(() => VmDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test("listApplications", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");

    final apps = await database.listApplications();

    expect(apps.length, 1);
    expect(apps[0].packageName, "me.efesser.flauncher");
    expect(apps[0].name, "FLauncher");
    expect(apps[0].version, "1.0.0");
    expect(apps[0].banner, null);
    expect(apps[0].icon, null);
  });

  test("persistApps", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    await database.persistApps(
        [AppsCompanion.insert(packageName: "me.efesser.flauncher", name: "FLauncher 2", version: "1.1.0")]);

    final app = await database.customSelect("SELECT * FROM apps;").getSingle();
    expect(app.read<String>("package_name"), "me.efesser.flauncher");
    expect(app.read<String>("name"), "FLauncher 2");
    expect(app.read<String>("version"), "1.1.0");
    expect(app.read<Uint8List?>("banner"), null);
    expect(app.read<Uint8List?>("icon"), null);
  });

  test("deleteApps", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher.2', 'FLauncher 2', '1.0.0', null, null);");

    await database.deleteApps(["me.efesser.flauncher"]);

    final app = await database.customSelect("SELECT * FROM apps;").getSingle();
    expect(app.read<String>("package_name"), "me.efesser.flauncher.2");
  });

  test("getCategory", () async {
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test 1', 2);");
    await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test 2', 2);");

    final category = await database.getCategory("Test 1");

    expect(category.id, categoryId);
    expect(category.name, "Test 1");
  });

  test("insertCategory", () async {
    await database.insertCategory(CategoriesCompanion.insert(name: "Test", order: 2));

    final category = await database.customSelect("SELECT * FROM categories WHERE name = 'Test';").getSingle();
    expect(category.read<String>("name"), "Test");
    expect(category.read<int>("order"), 2);
  });

  test("deleteCategory", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test', 2);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher', 0);");

    await database.deleteCategory(categoryId);

    final app = await database.customSelect("SELECT * FROM apps;").getSingle();
    expect(app.read<String>("package_name"), "me.efesser.flauncher");
    final appsCategories = await database.customSelect("SELECT * FROM apps_categories;").get();
    expect(appsCategories.length, 0);
    final categories = await database.customSelect("SELECT * FROM categories c ORDER BY c.'order' ASC;").get();
    expect(categories.length, 2);
    expect(categories[0].read<String>("name"), "Favorites");
    expect(categories[1].read<String>("name"), "Applications");
  });

  test("persistCategories", () async {
    final test1Id = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test 1', 2);");
    final test2Id = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test 2', 3);");

    await database.persistCategories([
      CategoriesCompanion(id: Value(test2Id), name: Value("Test 2"), order: Value(2)),
      CategoriesCompanion(id: Value(test1Id), name: Value("Test 1"), order: Value(3)),
    ]);

    final categories = await database.customSelect("SELECT * FROM categories c ORDER BY c.'order' ASC;").get();
    expect(categories.length, 4);
    expect(categories[0].read<String>("name"), "Favorites");
    expect(categories[1].read<String>("name"), "Applications");
    expect(categories[2].read<String>("name"), "Test 2");
    expect(categories[3].read<String>("name"), "Test 1");
  });

  test("insertAppCategory", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order')"
        " VALUES('Test', 2);");
    await database.insertAppCategory(
        AppsCategoriesCompanion.insert(categoryId: categoryId, appPackageName: "me.efesser.flauncher", order: 0));

    final appCategory = await database.customSelect("SELECT * FROM apps_categories;").getSingle();
    expect(appCategory.read<int>("category_id"), categoryId);
    expect(appCategory.read<String>("app_package_name"), "me.efesser.flauncher");
    expect(appCategory.read<int>("order"), 0);
  });

  test("deleteAppCategory", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test', 2);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher', 0);");

    await database.deleteAppCategory(categoryId, "me.efesser.flauncher");

    final app = await database.customSelect("SELECT * FROM apps;").getSingle();
    expect(app.read<String>("package_name"), "me.efesser.flauncher");
    final appsCategories = await database.customSelect("SELECT * FROM apps_categories;").get();
    expect(appsCategories.length, 0);
    final categories = await database.customSelect("SELECT * FROM categories c ORDER BY c.'order' ASC;").get();
    expect(categories.length, 3);
    expect(categories[0].read<String>("name"), "Favorites");
    expect(categories[1].read<String>("name"), "Applications");
    expect(categories[2].read<String>("name"), "Test");
  });

  test("persistAppsCategories", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test', 2);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher', 0);");

    await database.persistAppsCategories(
        [AppsCategoriesCompanion.insert(categoryId: categoryId, appPackageName: "me.efesser.flauncher", order: 1)]);

    final appCategory = await database.customSelect("SELECT * FROM apps_categories;").getSingle();
    expect(appCategory.read<int>("category_id"), categoryId);
    expect(appCategory.read<String>("app_package_name"), "me.efesser.flauncher");
    expect(appCategory.read<int>("order"), 1);
  });

  test("listCategoriesWithApps", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher.2', 'FLauncher 2', '1.0.0', null, null);");
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon, hidden)"
        " VALUES('me.efesser.flauncher.3', 'FLauncher 3', '1.0.0', null, null, true);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test', 2);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher', 1);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher.2', 0);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher.3', 2);");

    final categoriesWithApps = await database.listCategoriesWithApps();

    expect(categoriesWithApps.length, 3);
    expect(categoriesWithApps[0].category.name, "Favorites");
    expect(categoriesWithApps[1].category.name, "Applications");
    expect(categoriesWithApps[2].category.name, "Test");
    expect(categoriesWithApps[0].applications.length, 0);
    expect(categoriesWithApps[1].applications.length, 0);
    expect(categoriesWithApps[2].applications.length, 2);
    expect(categoriesWithApps[2].applications[0].packageName, "me.efesser.flauncher.2");
    expect(categoriesWithApps[2].applications[0].name, "FLauncher 2");
    expect(categoriesWithApps[2].applications[1].packageName, "me.efesser.flauncher");
    expect(categoriesWithApps[2].applications[1].name, "FLauncher");
  });

  test("nextAppCategoryOrder", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    final categoryId = await database.customInsert("INSERT INTO categories(name, 'order') VALUES('Test', 2);");
    await database.customInsert("INSERT INTO apps_categories(category_id, app_package_name, 'order')"
        " VALUES($categoryId, 'me.efesser.flauncher', 1);");

    final index = await database.nextAppCategoryOrder(categoryId);

    expect(index, 2);
  });

  test("listHiddenApplications", () async {
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon)"
        " VALUES('me.efesser.flauncher', 'FLauncher', '1.0.0', null, null);");
    await database.customInsert("INSERT INTO apps(package_name, name, version, banner, icon, hidden)"
        " VALUES('me.efesser.flauncher.2', 'FLauncher 2', '2.0.0', null, null, true);");

    final hiddenApplications = await database.listHiddenApplications();

    expect(hiddenApplications.length, 1);
    expect(hiddenApplications[0].name, "FLauncher 2");
    expect(hiddenApplications[0].packageName, "me.efesser.flauncher.2");
  });
}
