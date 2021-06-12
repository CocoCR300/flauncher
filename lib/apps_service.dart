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

import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

class AppsService extends ChangeNotifier {
  final FLauncherChannel _fLauncherChannel;
  final FLauncherDatabase _database;

  List<CategoryWithApps> _categoriesWithApps = [];

  List<CategoryWithApps> get categoriesWithApps => _categoriesWithApps
      .map((item) => CategoryWithApps(item.category, UnmodifiableListView(item.applications)))
      .toList(growable: false);

  AppsService(this._fLauncherChannel, this._database) {
    _init();
  }

  Future<void> _init() async {
    await _refreshState();
    _fLauncherChannel.addAppsChangedListener(_onAppsChanged);
  }

  Future<void> _onAppsChanged(Map<dynamic, dynamic> event) async {
    await _refreshState();
  }

  Future<void> _refreshState() async {
    final appsFromSystem = (await _fLauncherChannel.getInstalledApplications())
        .map((data) => AppsCompanion.insert(
              packageName: data["packageName"],
              name: data["name"],
              className: data["className"],
              version: data["version"],
              banner: Value(data["banner"]),
              icon: Value(data["icon"]),
            ))
        .toList();

    List<App> applications = await _database.listApplications();

    final List<String> newAppsPackages = appsFromSystem
        .map((systemApp) => systemApp.packageName.value)
        .where((systemApp) => !applications.any((app) => app.packageName == systemApp))
        .toList();

    final uninstalledApplications = applications
        .where((app) => !appsFromSystem.any((systemApp) => systemApp.packageName.value == app.packageName))
        .map((app) => app.toCompanion(false))
        .toList();

    await _database.persistApps(appsFromSystem);
    await _database.deleteApps(uninstalledApplications);
    applications = await _database.listApplications();

    if (newAppsPackages.isNotEmpty) {
      int index = await _database.nextAppCategoryOrder(CategoriesCompanion(name: Value("Applications")));
      final newAppCategories = newAppsPackages
          .map((systemAppPackage) => AppsCategoriesCompanion.insert(
              categoryName: "Applications", appPackageName: systemAppPackage, order: index++))
          .toList();
      await _database.persistAppsCategories(newAppCategories);
    }
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }

  Future<void> launchApp(App app) => _fLauncherChannel.launchApp(app.packageName, app.className);

  Future<void> openAppInfo(App app) => _fLauncherChannel.openAppInfo(app.packageName);

  Future<void> uninstallApp(App app) => _fLauncherChannel.uninstallApp(app.packageName);

  Future<void> openSettings() => _fLauncherChannel.openSettings();

  Future<bool> isDefaultLauncher() => _fLauncherChannel.isDefaultLauncher();

  Future<void> moveToCategory(App app, Category oldCategory, Category newCategory) async {
    await _database.deleteAppCategory(
      AppsCategoriesCompanion(
        categoryName: Value(oldCategory.name),
        appPackageName: Value(app.packageName),
      ),
    );

    int index = await _database.nextAppCategoryOrder(newCategory.toCompanion(false));
    await _database.insertAppCategory(
      AppsCategoriesCompanion.insert(
        categoryName: newCategory.name,
        appPackageName: app.packageName,
        order: index,
      ),
    );
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }

  Future<void> saveOrderInCategory(Category category) async {
    final applications = _categoriesWithApps.firstWhere((element) => element.category == category).applications;
    final orderedAppCategories = <AppsCategoriesCompanion>[];
    for (int i = 0; i < applications.length; ++i) {
      orderedAppCategories.add(AppsCategoriesCompanion(
        categoryName: Value(category.name),
        appPackageName: Value(applications[i].packageName),
        order: Value(i),
      ));
    }
    await _database.persistAppsCategories(orderedAppCategories);
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }

  void moveApplication(Category category, int oldIndex, int newIndex) {
    final applications = _categoriesWithApps.firstWhere((element) => element.category == category).applications;
    final application = applications.removeAt(oldIndex);
    applications.insert(newIndex, application);
    notifyListeners();
  }

  Future<void> addCategory(String categoryName) async {
    if (_categoriesWithApps.any((element) => element.category.name == categoryName)) {
      return;
    }
    final orderedCategories = <CategoriesCompanion>[];
    for (int i = 0; i < _categoriesWithApps.length; ++i) {
      orderedCategories.add(_categoriesWithApps[i].category.toCompanion(false).copyWith(order: Value(i + 1)));
    }
    await _database.insertCategory(CategoriesCompanion.insert(name: categoryName, order: 0));
    await _database.persistCategories(orderedCategories);
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    final applicationsCategory = _categoriesWithApps.firstWhere((e) => e.category.name == "Applications").category;
    final applications = _categoriesWithApps.firstWhere((element) => element.category == category).applications;
    int index = await _database.nextAppCategoryOrder(applicationsCategory.toCompanion(false));
    var appsCategories = applications
        .map((app) => AppsCategoriesCompanion.insert(
              categoryName: applicationsCategory.name,
              appPackageName: app.packageName,
              order: index++,
            ))
        .toList();
    await _database.persistAppsCategories(appsCategories);
    await _database.deleteCategory(category.toCompanion(false));
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }

  Future<void> moveCategory(int oldIndex, int newIndex) async {
    final categoryWithApps = _categoriesWithApps.removeAt(oldIndex);
    _categoriesWithApps.insert(newIndex, categoryWithApps);
    final orderedCategories = <CategoriesCompanion>[];
    for (int i = 0; i < _categoriesWithApps.length; ++i) {
      orderedCategories.add(_categoriesWithApps[i].category.toCompanion(false).copyWith(order: Value(i)));
    }
    await _database.persistCategories(orderedCategories);
    _categoriesWithApps = await _database.listCategoriesWithApps();
    notifyListeners();
  }
}
