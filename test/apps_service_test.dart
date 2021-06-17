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

import 'package:flauncher/apps_service.dart';
import 'package:flauncher/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

import 'mocks.dart';
import 'mocks.mocks.dart';

void main() {
  group("AppsService initialised correctly", () {
    test("with empty database", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([
            {
              'packageName': 'me.efesser.flauncher',
              'name': 'FLauncher',
              'className': '.MainActivity',
              'version': '1.0.0',
              'banner': null,
              'icon': null,
            }
          ]));
      when(database.listApplications()).thenAnswer((_) => Future.value([]));
      when(database.listCategoriesWithApps()).thenAnswer((_) => Future.value([]));
      when(database.nextAppCategoryOrder(CategoriesCompanion(name: Value("Applications"))))
          .thenAnswer((_) => Future.value(0));
      AppsService(channel, database);
      await untilCalled(database.listCategoriesWithApps());

      verify(database.persistApps([
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          className: ".MainActivity",
          version: "1.0.0",
          banner: Value(null),
          icon: Value(null),
        )
      ]));
      verify(database.listApplications()).called(2);
      verify(database.persistAppsCategories([
        AppsCategoriesCompanion.insert(categoryName: "Applications", appPackageName: "me.efesser.flauncher", order: 0)
      ]));
      verify(database.listCategoriesWithApps());
    });

    test("with newly installed, uninstalled and existing apps", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([
            {
              'packageName': 'me.efesser.flauncher',
              'name': 'FLauncher',
              'className': '.MainActivity',
              'version': '2.0.0',
              'banner': null,
              'icon': null,
            },
            {
              'packageName': 'me.efesser.flauncher.2',
              'name': 'FLauncher 2',
              'className': '.MainActivity',
              'version': '1.0.0',
              'banner': null,
              'icon': null,
            }
          ]));
      when(database.listApplications()).thenAnswer((_) => Future.value([
            fakeApp("me.efesser.flauncher", "FLauncher", ".MainActivity", "1.0.0", null, null),
            fakeApp("uninstalled.app", "Uninstalled Application", ".MainActivity", "1.0.0", null, null)
          ]));
      when(database.listCategoriesWithApps()).thenAnswer((_) => Future.value([]));
      when(database.nextAppCategoryOrder(CategoriesCompanion(name: Value("Applications"))))
          .thenAnswer((_) => Future.value(1));
      AppsService(channel, database);
      await untilCalled(database.listCategoriesWithApps());

      verify(database.persistApps([
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          className: ".MainActivity",
          version: "2.0.0",
          banner: Value(null),
          icon: Value(null),
        ),
        AppsCompanion.insert(
          packageName: "me.efesser.flauncher.2",
          name: "FLauncher 2",
          className: ".MainActivity",
          version: "1.0.0",
          banner: Value(null),
          icon: Value(null),
        )
      ]));
      verify(database.deleteApps([
        AppsCompanion.insert(
          packageName: "uninstalled.app",
          name: "Uninstalled Application",
          className: ".MainActivity",
          version: "1.0.0",
          banner: Value(null),
          icon: Value(null),
        )
      ]));
      verify(database.listApplications()).called(2);
      verify(database.persistAppsCategories([
        AppsCategoriesCompanion.insert(categoryName: "Applications", appPackageName: "me.efesser.flauncher.2", order: 1)
      ]));
      verify(database.listCategoriesWithApps());
    });
  });

  test("launchApp calls channel", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final appsService = await _buildInitialisedAppsService(channel, database, []);
    final app = fakeApp();

    await appsService.launchApp(app);

    verify(channel.launchApp(app.packageName, app.className));
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
    when(database.nextAppCategoryOrder(CategoriesCompanion(name: Value("New Category"), order: Value(0))))
        .thenAnswer((_) => Future.value(1));

    await appsService.moveToCategory(
        fakeApp("app.to.be.moved"), fakeCategory("Old Category"), fakeCategory("New Category"));

    verify(database.deleteAppCategory(
        AppsCategoriesCompanion(categoryName: Value("Old Category"), appPackageName: Value("app.to.be.moved"))));
    verify(database.insertAppCategory(
        AppsCategoriesCompanion.insert(categoryName: "New Category", appPackageName: "app.to.be.moved", order: 1)));
    verify(database.listCategoriesWithApps());
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
      AppsCategoriesCompanion.insert(categoryName: "Category", appPackageName: "app.1", order: 0),
      AppsCategoriesCompanion.insert(categoryName: "Category", appPackageName: "app.2", order: 1)
    ]));
    verify(database.listCategoriesWithApps());
  });

  test("moveApplication changes application order in-memory", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final category = fakeCategory("Category");
    final appsService = await _buildInitialisedAppsService(channel, database, [
      CategoryWithApps(category, [fakeApp("app.1"), fakeApp("app.2")])
    ]);

    appsService.moveApplication(category, 1, 0);

    expect(appsService.categoriesWithApps[0].applications[0].packageName, "app.2");
    expect(appsService.categoriesWithApps[0].applications[1].packageName, "app.1");
  });

  group("addCategory", () {
    test("adds category at index 0 and moves others", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(fakeCategory("Existing Category", 0), [])],
      );

      await appsService.addCategory("New Category");

      verify(database.insertCategory(CategoriesCompanion.insert(name: "New Category", order: 0)));
      verify(database.persistCategories([CategoriesCompanion.insert(name: "Existing Category", order: 1)]));
      verify(database.listCategoriesWithApps());
    });

    test("with existing category name does nothing", () async {
      final channel = MockFLauncherChannel();
      final database = MockFLauncherDatabase();
      final appsService = await _buildInitialisedAppsService(
        channel,
        database,
        [CategoryWithApps(fakeCategory("Existing Category", 0), [])],
      );

      await appsService.addCategory("Existing Category");

      verifyZeroInteractions(database);
    });
  });

  test("deleteCategory deletes category and moves apps to default one", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final defaultCategory = fakeCategory("Applications", 0);
    final categoryToDelete = fakeCategory("Delete Me", 1);
    final appInDefaultCategory = fakeApp();
    final appInCategoryToDelete = fakeApp("app.to.be.moved");
    final appsService = await _buildInitialisedAppsService(
      channel,
      database,
      [
        CategoryWithApps(defaultCategory, [appInDefaultCategory]),
        CategoryWithApps(categoryToDelete, [appInCategoryToDelete])
      ],
    );
    when(database.nextAppCategoryOrder(defaultCategory.toCompanion(false))).thenAnswer((_) => Future.value(1));

    await appsService.deleteCategory(categoryToDelete);

    verify(database.persistAppsCategories(
      [AppsCategoriesCompanion.insert(categoryName: "Applications", appPackageName: "app.to.be.moved", order: 1)],
    ));
    verify(database.deleteCategory(categoryToDelete.toCompanion(false)));
    verify(database.listCategoriesWithApps());
  });

  test("moveCategory changes categories order", () async {
    final channel = MockFLauncherChannel();
    final database = MockFLauncherDatabase();
    final defaultCategory = fakeCategory("Applications", 0);
    final categoryToDelete = fakeCategory("Favorites", 1);
    final appsService = await _buildInitialisedAppsService(
      channel,
      database,
      [CategoryWithApps(defaultCategory, []), CategoryWithApps(categoryToDelete, [])],
    );
    when(database.nextAppCategoryOrder(defaultCategory.toCompanion(false))).thenAnswer((_) => Future.value(1));

    await appsService.moveCategory(1, 0);

    verify(database.persistCategories(
      [
        CategoriesCompanion.insert(name: "Favorites", order: 0),
        CategoriesCompanion.insert(name: "Applications", order: 1)
      ],
    ));
    verify(database.listCategoriesWithApps());
  });
}

Future<AppsService> _buildInitialisedAppsService(
  MockFLauncherChannel channel,
  MockFLauncherDatabase database,
  List<CategoryWithApps> categoriesWithApps,
) async {
  when(channel.getInstalledApplications()).thenAnswer((_) => Future.value([]));
  when(database.listApplications()).thenAnswer((_) => Future.value([]));
  when(database.listCategoriesWithApps()).thenAnswer((_) => Future.value(categoriesWithApps));
  final appsService = AppsService(channel, database);
  await untilCalled(database.listCategoriesWithApps());
  clearInteractions(channel);
  clearInteractions(database);
  return appsService;
}
