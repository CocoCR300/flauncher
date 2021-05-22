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

import 'package:flauncher/application_info.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/foundation.dart';

class Apps extends ChangeNotifier {
  final FLauncherChannel _fLauncherChannel;
  List<ApplicationInfo> _apps = [];

  List<ApplicationInfo> get installedApplications => _apps;

  Apps(this._fLauncherChannel) {
    _init();
  }

  Future<void> _init() async {
    final apps = await _fLauncherChannel.getInstalledApplications();
    _apps = apps.map((e) => ApplicationInfo.create(e)).toList();
    notifyListeners();
  }

  Future<void> launchApp(ApplicationInfo app) =>
      _fLauncherChannel.launchApp(app.packageName, app.className);

  Future<void> openSettings() => _fLauncherChannel.openSettings();
}
