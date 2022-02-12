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

import 'dart:math';

import 'package:drift/drift.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/unsplash_service.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  FLauncherChannel,
  WallpaperService,
  AppsService,
  SettingsService,
  FirebaseCrashlytics,
  FirebaseAnalytics,
  FirebaseRemoteConfig,
  UnsplashService,
], customMocks: [
  MockSpec<FLauncherDatabase>(unsupportedMembers: {#alias}),
])
void main() {}

App fakeApp({
  String packageName = "me.efesser.flauncher",
  String name = "FLauncher",
  String version = "1.0.0",
  Uint8List? banner,
  Uint8List? icon,
  bool hidden = false,
  bool sideloaded = false,
}) =>
    App(
      packageName: packageName,
      name: name,
      version: version,
      banner: banner,
      icon: icon,
      hidden: hidden,
      sideloaded: sideloaded,
    );

Category fakeCategory({
  String name = "Favorites",
  int order = 0,
  CategorySort sort = CategorySort.manual,
  CategoryType type = CategoryType.grid,
  int rowHeight = 110,
  int columnsCount = 6,
}) =>
    Category(
      id: Random().nextInt(1 << 32),
      name: name,
      sort: sort,
      type: type,
      rowHeight: rowHeight,
      columnsCount: columnsCount,
      order: order,
    );
