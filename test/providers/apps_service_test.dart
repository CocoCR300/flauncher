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
import 'package:flauncher/providers/apps_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

void main() {
  group("AppsService initialised correctly", () {
    test("with empty database", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([
            {
              'packageName': 'me.efesser.flauncher',
              'name': 'FLauncher',
              'version': '1.0.0',
              'banner': null,
              'icon': null,
            }
          ]));
      when(database.listApplications()).thenAnswer((_) => Future.value([]));
      when(database.listHiddenApplications()).thenAnswer((_) => Future.value([]));
      when(database.listCategoriesWithVisibleApps()).thenAnswer((_) => Future.value([]));
      final applicationsCategory = fakeCategory("Applications", 0);
      when(database.getCategory("Applications")).thenAnswer((_) => Future.value(applicationsCategory));
      when(database.nextAppCategoryOrder(applicationsCategory.id)).thenAnswer((_) => Future.value(0));
      AppsService(channel, database);
      await untilCalled(database.listCategoriesWithVisibleApps());

      verify(database.persistApps([
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          version: "1.0.0",
          banner: Value(null),
          icon: Value(null),
        )
      ]));
      verify(database.listApplications()).called(2);
      verify(database.persistAppsCategories([
        AppsCategoriesCompanion.insert(
          categoryId: applicationsCategory.id,
          appPackageName: "me.efesser.flauncher",
          order: 0,
        )
      ]));
      verify(database.listCategoriesWithVisibleApps());
      verify(database.listHiddenApplications());
    });

    test("with newly installed, uninstalled and existing apps", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([
            {
              'packageName': 'me.efesser.flauncher',
              'name': 'FLauncher',
              'version': '2.0.0',
              'banner': null,
              'icon': null,
            },
            {
              'packageName': 'me.efesser.flauncher.2',
              'name': 'FLauncher 2',
              'version': '1.0.0',
              'banner': null,
              'icon': null,
            }
          ]));
      when(database.listApplications()).thenAnswer((_) => Future.value([
            fakeApp("me.efesser.flauncher", "FLauncher", "1.0.0", null, null),
            fakeApp("uninstalled.app", "Uninstalled Application", "1.0.0", null, null)
          ]));
      when(database.listHiddenApplications()).thenAnswer((_) => Future.value([]));
      when(database.listCategoriesWithVisibleApps()).thenAnswer((_) => Future.value([]));
      final applicationsCategory = fakeCategory("Applications", 0);
      when(database.getCategory("Applications")).thenAnswer((_) => Future.value(applicationsCategory));
      when(database.nextAppCategoryOrder(applicationsCategory.id)).thenAnswer((_) => Future.value(1));
      AppsService(channel, database);
      await untilCalled(database.listCategoriesWithVisibleApps());

      verify(database.persistApps([
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          version: "2.0.0",
          banner: Value(null),
          icon: Value(null),
        ),
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher.2",
          name: "FLauncher 2",
          version: "1.0.0",
          banner: Value(null),
          icon: Value(null),
        )
      ]));
      verify(database.deleteApps(["uninstalled.app"]));
      verify(database.listApplications()).called(2);
      verify(database.persistAppsCategories([
        AppsCategoriesCompanion.insert(
          categoryId: applicationsCategory.id,
          appPackageName: "me.efesser.flauncher.2",
          order: 1,
        )
      ]));
      verify(database.listCategoriesWithVisibleApps());
      verify(database.listHiddenApplications());
    });
  });

  test("launchApp calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);
    final app = fakeApp();

    await appsService.launchApp(app);
  });

  test("openAppInfo calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);
    final app = fakeApp();

    await appsService.openAppInfo(app);

    verify(channel.openAppInfo(app.packageName));
  });

  test("uninstallApp calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);
    final app = fakeApp();

    await appsService.uninstallApp(app);

    verify(channel.uninstallApp(app.packageName));
  });

  test("openSettings calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);

    await appsService.openSettings();

    verify(channel.openSettings());
  });

  test("isDefaultLauncher calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    when(channel.isDefaultLauncher()).thenAnswer((_) => Future.value(true));
    final appsService = await _buildInitialisedAppsService(channel, database, []);

    final isDefaultLauncher = await appsService.isDefaultLauncher();

    verify(channel.isDefaultLauncher());
    expect(isDefaultLauncher, isTrue);
  });

  test("moveToCategory moves app from one category to another", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);
    final oldCategory = fakeCategory("Old Category");
    final newCategory = fakeCategory("New Category");
    when(database.nextAppCategoryOrder(newCategory.id)).thenAnswer((_) => Future.value(1));

    await appsService.moveToCategory(fakeApp("app.to.be.moved"), oldCategory, newCategory);

    verify(database.deleteAppCategory(oldCategory.id, "app.to.be.moved"));
    verify(database.insertAppCategory(
        AppsCategoriesCompanion.insert(categoryId: newCategory.id, appPackageName: "app.to.be.moved", order: 1)));
    verify(database.listCategoriesWithVisibleApps());
  });

  test("saveOrderInCategory persists apps order from memory to database", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final category = fakeCategory("Category");
    final appsService = await _buildInitialisedAppsService(channel, database, [
      CategoryWithApps(category, [fakeApp("app.1"), fakeApp("app.2")])
    ]);

    await appsService.saveOrderInCategory(category);

    verify(database.persistAppsCategories([
      AppsCategoriesCompanion.insert(categoryId: category.id, appPackageName: "app.1", order: 0),
      AppsCategoriesCompanion.insert(categoryId: category.id, appPackageName: "app.2", order: 1)
    ]));
    verify(database.listCategoriesWithVisibleApps());
  });

  test("reorderApplication changes application order in-memory", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final category = fakeCategory("Category");
    final appsService = await _buildInitialisedAppsService(channel, database, [
      CategoryWithApps(category, [fakeApp("app.1"), fakeApp("app.2")])
    ]);

    appsService.reorderApplication(category, 1, 0);

    expect(appsService.categoriesWithApps[0].applications[0].packageName, "app.2");
    expect(appsService.categoriesWithApps[0].applications[1].packageName, "app.1");
  });

  group("addCategory", () {
    test("adds category at index 0 and moves others", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final existingCategory = fakeCategory("Existing Category", 0);
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(existingCategory, [])],
      );

      await appsService.addCategory("New Category");

      verify(database.insertCategory(CategoriesCompanion.insert(name: "New Category", order: 0)));
      verify(database.persistCategories(
          [CategoriesCompanion(id: Value(existingCategory.id), name: Value(existingCategory.name), order: Value(1))]));
      verify(database.listCategoriesWithVisibleApps());
    });

    test("with 'Applications' category name does nothing", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(fakeCategory("Applications", 0), [])],
      );

      await appsService.addCategory("Applications");

      verifyZeroInteractions(database);
    });
  });

  group("renameCategory", () {
    test("renames category", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final category = fakeCategory("Old name", 0);
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(category, [])],
      );

      await appsService.renameCategory(category, "New name");

      verify(database.persistCategories(
        [CategoriesCompanion(id: Value(category.id), name: Value("New name"), order: Value(0))],
      ));
      verify(database.listCategoriesWithVisibleApps());
    });

    test("with 'Applications' category name does nothing", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final category = fakeCategory("Old name", 0);
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(category, [])],
      );

      await appsService.renameCategory(category, "Applications");

      verifyZeroInteractions(database);
    });
  });

  test("deleteCategory deletes category and moves all its apps to default one", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final defaultCategory = fakeCategory("Applications", 0);
    final categoryToDelete = fakeCategory("Delete Me", 1);
    final appInDefaultCategory = fakeApp();
    final appInCategoryToDelete = fakeApp("app.to.be.moved.1");
    final hiddenAppInCategoryToDelete = fakeApp("app.to.be.moved.2").copyWith(hidden: true);
    final appsService = await _buildInitialisedAppsService(
      channel,
      database,
      [
        CategoryWithApps(defaultCategory, [appInDefaultCategory]),
        CategoryWithApps(categoryToDelete, [appInCategoryToDelete, hiddenAppInCategoryToDelete])
      ],
    );
    when(database.nextAppCategoryOrder(defaultCategory.id)).thenAnswer((_) => Future.value(1));
    when(database.listCategoryApps(categoryToDelete.id))
        .thenAnswer((_) => Future.value([appInCategoryToDelete, hiddenAppInCategoryToDelete]));

    await appsService.deleteCategory(categoryToDelete);

    verify(database.persistAppsCategories(
      [
        AppsCategoriesCompanion.insert(categoryId: defaultCategory.id, appPackageName: "app.to.be.moved.1", order: 1),
        AppsCategoriesCompanion.insert(categoryId: defaultCategory.id, appPackageName: "app.to.be.moved.2", order: 2),
      ],
    ));
    verify(database.deleteCategory(categoryToDelete.id));
    verify(database.listCategoriesWithVisibleApps());
  });

  test("moveCategory changes categories order", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final applicationsCategory = fakeCategory("Applications", 0);
    final favoritesCategory = fakeCategory("Favorites", 1);
    final appsService = await _buildInitialisedAppsService(
      channel,
      database,
      [CategoryWithApps(applicationsCategory, []), CategoryWithApps(favoritesCategory, [])],
    );
    when(database.nextAppCategoryOrder(applicationsCategory.id)).thenAnswer((_) => Future.value(1));

    await appsService.moveCategory(1, 0);

    verify(database.persistCategories(
      [
        CategoriesCompanion(id: Value(favoritesCategory.id), name: Value("Favorites"), order: Value(0)),
        CategoriesCompanion(id: Value(applicationsCategory.id), name: Value("Applications"), order: Value(1))
      ],
    ));
    verify(database.listCategoriesWithVisibleApps());
  });

  test("hideApplication hides application", () async {
    final database = MockFLauncherDatabase();
    final application = fakeApp();
    final appsService = await _buildInitialisedAppsService(MockFLauncherChannel(), database, []);
    when(database.listHiddenApplications()).thenAnswer((_) => Future.value([application]));

    await appsService.hideApplication(application);

    verify(database.persistApps([application.toCompanion(false).copyWith(hidden: Value(true))]));
    verify(database.listCategoriesWithVisibleApps());
    verify(database.listHiddenApplications());
    expect(appsService.hiddenApplications, [application]);
  });

  test("unHideApplication hides application", () async {
    final database = MockFLauncherDatabase();
    final application = fakeApp();
    final appsService = await _buildInitialisedAppsService(MockFLauncherChannel(), database, []);

    await appsService.unHideApplication(application);

    verify(database.persistApps([application.toCompanion(false).copyWith(hidden: Value(false))]));
    verify(database.listCategoriesWithVisibleApps());
    verify(database.listHiddenApplications());
  });
}

Future<AppsService> _buildInitialisedAppsService(
  MockFLauncherChannel channel,
  MockFLauncherDatabase database,
  List<CategoryWithApps> categoriesWithApps,
) async {
  when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([]));
  when(database.listApplications()).thenAnswer((_) => Future.value([]));
  when(database.listHiddenApplications()).thenAnswer((_) => Future.value([]));
  when(database.listCategoriesWithVisibleApps()).thenAnswer((_) => Future.value(categoriesWithApps));
  final appsService = AppsService(channel, database);
  await untilCalled(database.listCategoriesWithVisibleApps());
  clearInteractions(channel);
  clearInteractions(database);
  return appsService;
}
