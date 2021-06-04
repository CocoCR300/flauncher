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

import 'package:flauncher/application_info.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _favoritesPackagesKey = "favorites_packages";

class Apps extends ChangeNotifier {
  final FLauncherChannel _fLauncherChannel;
  final SharedPreferences _sharedPreferences;

  List<ApplicationInfo> _applications = [];

  List<ApplicationInfo> get applications => _applications;

  List<ApplicationInfo> get favorites =>
      _applications.where((app) => app.favorited).toList();

  Apps(this._fLauncherChannel, this._sharedPreferences) {
    _init();
  }

  Future<void> _init() async {
    await _refreshState();
    _fLauncherChannel.addAppsChangedListener(_onAppsChanged);
    notifyListeners();
  }

  Future<void> _onAppsChanged(Map<dynamic, dynamic> event) async {
    await _refreshState();
    notifyListeners();
  }

  Future<void> _refreshState() async {
    final apps = await _fLauncherChannel.getInstalledApplications();
    final favorites = _getFavorites();
    _applications = apps.map((app) {
      final applicationInfo = ApplicationInfo.create(app);
      applicationInfo.favorited =
          favorites.contains(applicationInfo.packageName);
      return applicationInfo;
    }).toList();
    final packages = _applications.map((app) => app.packageName);
    favorites.removeWhere((favorite) => !packages.contains(favorite));
    await _persistFavorites(favorites);
  }

  Set<String> _getFavorites() =>
      _sharedPreferences.getStringList(_favoritesPackagesKey)?.toSet() ?? {};

  Future<bool> _persistFavorites(Set<String> favorites) => _sharedPreferences
      .setStringList(_favoritesPackagesKey, favorites.toList());

  Future<void> launchApp(ApplicationInfo app) =>
      _fLauncherChannel.launchApp(app.packageName, app.className);

  Future<void> openSettings() => _fLauncherChannel.openSettings();

  Future<void> openAppInfo(ApplicationInfo app) =>
      _fLauncherChannel.openAppInfo(app.packageName);

  Future<void> uninstallApp(ApplicationInfo app) =>
      _fLauncherChannel.uninstallApp(app.packageName);

  Future<bool> isDefaultLauncher() => _fLauncherChannel.isDefaultLauncher();

  Future<void> addToFavorites(ApplicationInfo applicationInfo) async {
    final favorites = _getFavorites();
    favorites.add(applicationInfo.packageName);
    _applications
        .firstWhere((app) => app.packageName == applicationInfo.packageName)
        .favorited = true;
    await _persistFavorites(favorites);
    notifyListeners();
  }

  Future<void> removeFromFavorites(ApplicationInfo applicationInfo) async {
    final favorites = _getFavorites();
    favorites.remove(applicationInfo.packageName);
    _applications
        .firstWhere((app) => app.packageName == applicationInfo.packageName)
        .favorited = false;
    await _persistFavorites(favorites);
    notifyListeners();
  }
}
