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

import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart' as collection;

import 'package:drift/drift.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:tuple/tuple.dart';

import '../models/app.dart';
import '../models/category.dart';

class AppsService extends ChangeNotifier {
  final FLauncherChannel _fLauncherChannel;
  final FLauncherDatabase _database;

  bool _initialized = false;

  List<AppCategory> _appsCategories = [];
  List<App> _applications = [];
  List<Category> _categories = [];

  bool get initialized => _initialized;

  List<App> get applications => UnmodifiableListView(_applications);

  List<Category> get categories => _categories
      .map((category) => category.unmodifiable())
      .toList(growable: false);

  AppsService(this._fLauncherChannel, this._database) {
    _init();
  }

  Future<void> _init() async {
    await _refreshState(shouldNotifyListeners: false);
    if (_database.wasCreated) {
      await _initDefaultCategories();
    }
    _fLauncherChannel.addAppsChangedListener((event) async {
      switch (event["action"]) {
        case "PACKAGE_ADDED":
        case "PACKAGE_CHANGED":
          await _database.persistApps([_buildAppCompanion(event["activityInfo"])]);
          break;
        case "PACKAGES_AVAILABLE":
          List<dynamic> appsInfo = event["activitiesInfo"];
          await _database.persistApps((appsInfo).map(_buildAppCompanion).toList());
          break;
        case "PACKAGE_REMOVED":
          await _database.deleteApps([event["packageName"]]);
          break;
      }

      _getApplicationsFromDatabase();
      notifyListeners();
    });
    _initialized = true;
    notifyListeners();
  }

  AppsCompanion _buildAppCompanion(dynamic data) => AppsCompanion(
        packageName: Value(data["packageName"]),
        name: Value(data["name"]),
        version: Value(data["version"] ?? "(unknown)"),
        hidden: const Value.absent(),
        sideloaded: Value(data["sideloaded"]),
      );

  Future<void> _initDefaultCategories() => _database.transaction(() async {
    final tvApplications = _applications.where((element) => element.sideloaded == false);
    final nonTvApplications = _applications.where((element) => element.sideloaded == true);

    if (tvApplications.isNotEmpty) {
      await addCategory("TV Applications", shouldNotifyListeners: false);
      final tvAppsCategory =
          _categories.firstWhere((category) => category.name == "TV Applications");
      await setCategoryType(
        tvAppsCategory,
        CategoryType.grid,
        shouldNotifyListeners: false,
      );
      for (final app in tvApplications) {
        await addToCategory(app, tvAppsCategory, shouldNotifyListeners: false);
      }
    }
    if (nonTvApplications.isNotEmpty) {
      await addCategory(
        "Non-TV Applications",
        shouldNotifyListeners: false,
      );
      final nonTvAppsCategory =
          _categories.firstWhere((category) => category.name == "Non-TV Applications");
      for (final app in nonTvApplications) {
        await addToCategory(app, nonTvAppsCategory, shouldNotifyListeners: false);
      }
    }
  });

  Future<void> _refreshState({bool shouldNotifyListeners = true}) async {
    Future<List<App>> appsFromDatabaseFuture = _database.getApplications();
    Future<List<AppCategory>> appsCategoriesFuture = _database.getAppsCategories();
    Future<List<Category>> categoriesFuture = _database.getCategories();
    List<Map<dynamic, dynamic>> appsFromSystem = await _fLauncherChannel.getApplications();
    Iterable<MapEntry<String, Tuple2<Map, AppsCompanion>>> appEntries = appsFromSystem.map(
            (appFromSystem) => new MapEntry(appFromSystem['packageName'], Tuple2(appFromSystem, _buildAppCompanion(appFromSystem))));
    Map<String, Tuple2<Map, AppsCompanion>> appsFromSystemByPackageName = Map.fromEntries(appEntries);

    List<App> appsFromDatabase = await appsFromDatabaseFuture;
    final appsRemovedFromSystem = appsFromDatabase
        .where((app) => !appsFromSystemByPackageName.containsKey(app.packageName));

    final List<String> uninstalledApplications = [];
    for (App app in appsRemovedFromSystem) {
      String packageName = app.packageName;

      // TODO: Is this really necessary? Can't we get this information from the getApplications method?
      bool appExists = await _fLauncherChannel.applicationExists(packageName);
      if (!appExists) {
        uninstalledApplications.add(packageName);
      }
    }

    await _database.transaction(() async {
      await _database.persistApps(appsFromSystemByPackageName.values.map((tuple) => tuple.item2));
      await _database.deleteApps(uninstalledApplications);
    });

    _appsCategories = await appsCategoriesFuture;
    _categories = await categoriesFuture;
    _applications = await _database.listApplications();

    // TODO: This one is not quite there, the "hidden" data is missing
    //_applications = appsFromSystemByPackageName.values.map((tuple) => App.fromSystem(tuple.item1)).where((app) => !uninstalledApplications.contains(app.packageName)).toList();

    for (App application in _applications) {
      var applicationFromSystem = appsFromSystemByPackageName[application.packageName];
      if (applicationFromSystem!.item1.containsKey('action')) {
        application.action = applicationFromSystem.item1['action'];
      }

      if (_appsCategories.isNotEmpty && !application.hidden) {
        int appCategoryIndex = _appsCategories.binarySearchBy(AppCategory(categoryId: 0, appPackageName: application.packageName, order: 0), (a) => a.appPackageName);
        AppCategory appCategory = _appsCategories[appCategoryIndex];
        int categoryIndex = _categories.binarySearchByCompare(
            Category(
                id: appCategory.categoryId,
                name: "",
                sort: CategorySort.alphabetical,
                type: CategoryType.grid,
                rowHeight: 0,
                columnsCount: 0,
                order: 0),
                (c) => c.id,
                (o, o1) => o.compareTo(o1));

        if (categoryIndex > -1) {
          Category category = _categories[categoryIndex];
          category.applications.add(application);
        }
      }
    }

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  Future<void> _getApplicationsFromDatabase() async {
    List<Map<dynamic, dynamic>> appsFromSystem = await _fLauncherChannel.getApplications();
    Iterable<MapEntry<String, Tuple2<Map, AppsCompanion>>> appEntries = appsFromSystem.map(
            (appFromSystem) => new MapEntry(appFromSystem['packageName'], Tuple2(appFromSystem, _buildAppCompanion(appFromSystem))));
    Map<String, Tuple2<Map, AppsCompanion>> appsFromSystemByPackageName = Map.fromEntries(appEntries);

    _appsCategories = await _database.getAppsCategories();
    _categories = await _database.getCategories();
    _applications = await _database.listApplications();

    // TODO: This one is not quite there, the "hidden" data is missing
    //_applications = appsFromSystemByPackageName.values.map((tuple) => App.fromSystem(tuple.item1)).where((app) => !uninstalledApplications.contains(app.packageName)).toList();

    for (App application in _applications) {
      var applicationFromSystem = appsFromSystemByPackageName[application.packageName];
      if (applicationFromSystem!.item1.containsKey('action')) {
        application.action = applicationFromSystem.item1['action'];
      }

      if (_appsCategories.isNotEmpty && !application.hidden) {
        // TODO: An application can be in multiple categories, this code does not take that into account
        int appCategoryIndex = _appsCategories.binarySearchBy(AppCategory(categoryId: 0, appPackageName: application.packageName, order: 0), (a) => a.appPackageName);
        AppCategory appCategory = _appsCategories[appCategoryIndex];
        int categoryIndex = _categories.binarySearchByCompare(
            Category(
                id: appCategory.categoryId,
                name: "",
                sort: CategorySort.alphabetical,
                type: CategoryType.grid,
                rowHeight: 0,
                columnsCount: 0,
                order: 0),
                (c) => c.id,
                (o, o1) => o.compareTo(o1));

        if (categoryIndex > -1) {
          Category category = _categories[categoryIndex];
          category.applications.add(application);
        }
      }
    }
  }

  Future<Uint8List> getAppBanner(String packageName) {
    return _fLauncherChannel.getApplicationBanner(packageName);
  }

  Future<Uint8List> getAppIcon(String packageName) {
    return _fLauncherChannel.getApplicationIcon(packageName);
  }

  Future<void> launchApp(App app) {
    Future<void> future;
    if (app.action == null) {
      future = _fLauncherChannel.launchApp(app.packageName);
    }
    else {
      future = _fLauncherChannel.launchActivityFromAction(app.action!);
    }

    return future;
  }

  Future<void> openAppInfo(App app) => _fLauncherChannel.openAppInfo(app.packageName);

  Future<void> uninstallApp(App app) => _fLauncherChannel.uninstallApp(app.packageName);

  Future<void> openSettings() => _fLauncherChannel.openSettings();

  Future<bool> isDefaultLauncher() => _fLauncherChannel.isDefaultLauncher();

  Future<void> startAmbientMode() => _fLauncherChannel.startAmbientMode();

  Future<void> addToCategory(App app, Category category, {bool shouldNotifyListeners = true}) async {
    int index = await _database.nextAppCategoryOrder(category.id) ?? 0;
    await _database.insertAppsCategories([
      AppsCategoriesCompanion.insert(
        categoryId: category.id,
        appPackageName: app.packageName,
        order: index,
      )
    ]);

    Category? categoryFound = _categories
        .firstWhereOrNull((category0) => category0.id == category.id);

    if (categoryFound != null) {
      category.applications.add(app);
    }

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  Future<void> removeFromCategory(App app, Category category) async {
    await _database.deleteAppCategory(category.id, app.packageName);
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  Future<void> saveOrderInCategory(Category category) async {
    final applications = _categories.firstWhere((category0) => category0.id == category.id).applications;
    final orderedAppCategories = <AppsCategoriesCompanion>[];
    for (int i = 0; i < applications.length; ++i) {
      orderedAppCategories.add(AppsCategoriesCompanion(
        categoryId: Value(category.id),
        appPackageName: Value(applications[i].packageName),
        order: Value(i),
      ));
    }
    await _database.replaceAppsCategories(orderedAppCategories);
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  void reorderApplication(Category category, int oldIndex, int newIndex) {
    final applications = _categories.firstWhere((category0) => category0.id == category.id).applications;
    final application = applications.removeAt(oldIndex);
    applications.insert(newIndex, application);
    notifyListeners();
  }

  Future<void> addCategory(String categoryName, {bool shouldNotifyListeners = true}) async {
    List<CategoriesCompanion> orderedCategories = [];
    for (int i = 0; i < _categories.length; ++i) {
      final category = _categories[i];
      orderedCategories.add(CategoriesCompanion(id: Value(category.id), order: Value(i + 1)));
    }

    int newCategoryId = 0;
    try {
      await _database.transaction(() async {
        newCategoryId = await _database.insertCategory(CategoriesCompanion.insert(name: categoryName, order: 0));
        await _database.updateCategories(orderedCategories);
      });

      Category newCategory = Category(id: newCategoryId, name: categoryName, order: 0);
      for (int i = 0; i < _categories.length; ++i) {
        Category category = _categories[i];
        category.order = i + 1;
      }
      _categories.insert(0, newCategory);

      if (shouldNotifyListeners) {
        notifyListeners();
      }
    }
    catch (ex) { }
  }

  Future<void> renameCategory(Category category, String categoryName) async {
    await _database.updateCategory(category.id, CategoriesCompanion(name: Value(categoryName)));
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await _database.deleteCategory(category.id);
    _categories.removeWhere((category0) => category0.id == category.id);
    notifyListeners();
  }

  Future<void> moveCategory(int oldIndex, int newIndex) async {
    final categoryWithApps = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, categoryWithApps);
    final orderedCategories = <CategoriesCompanion>[];
    for (int i = 0; i < _categories.length; ++i) {
      final category = _categories[i];
      orderedCategories.add(CategoriesCompanion(id: Value(category.id), order: Value(i)));
    }
    await _database.updateCategories(orderedCategories);
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  Future<void> hideApplication(App application) async {
    await _database.updateApp(application.packageName, const AppsCompanion(hidden: Value(true)));
    App? applicationFound = _applications.firstWhereOrNull((application0) => application0.packageName == application.packageName);

    if (applicationFound != null) {
      applicationFound.hidden = true;

      for (Category category in _categories) {
        category.applications.removeWhere((application0) => application0.packageName == application.packageName);
      }
    }
    notifyListeners();
  }

  Future<void> showApplication(App application) async {
    await _database.updateApp(application.packageName, const AppsCompanion(hidden: Value(false)));
    App? applicationFound = _applications.firstWhereOrNull((application0) => application0.packageName == application.packageName);

    if (applicationFound != null) {
      applicationFound.hidden = false;

      int appCategoryIndex = 0;
      while (appCategoryIndex > -1) {
        appCategoryIndex = _appsCategories.binarySearchBy(
            AppCategory(categoryId: 0, appPackageName: application.packageName, order: 0),
            (appCategory) => appCategory.appPackageName,
            appCategoryIndex);

        if (appCategoryIndex > -1) {
          AppCategory appCategory = _appsCategories[appCategoryIndex];
          Category category = _categories.firstWhere((category) => category.id == appCategory.categoryId);
          category.applications.add(application);
          category.applications.sortBy((application) => application.name);

          appCategoryIndex +=  1;
        }
      }
    }
    notifyListeners();
  }

  Future<void> setCategoryType(Category category, CategoryType type, {bool shouldNotifyListeners = true}) async {
    await _database.updateCategory(category.id, CategoriesCompanion(type: Value(type)));
    _getApplicationsFromDatabase();

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  Future<void> setCategorySort(Category category, CategorySort sort) async {
    await _database.updateCategory(category.id, CategoriesCompanion(sort: Value(sort)));
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  Future<void> setCategoryColumnsCount(Category category, int columnsCount) async {
    await _database.updateCategory(category.id, CategoriesCompanion(columnsCount: Value(columnsCount)));
    _getApplicationsFromDatabase();
    notifyListeners();
  }

  Future<void> setCategoryRowHeight(Category category, int rowHeight) async {
    await _database.updateCategory(category.id, CategoriesCompanion(rowHeight: Value(rowHeight)));
    _getApplicationsFromDatabase();
    notifyListeners();
  }
}
