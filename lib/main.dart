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
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flauncher/apps_service.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/settings_service.dart';
import 'package:flauncher/wallpaper_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final firebaseCrashlytics = FirebaseCrashlytics.instance;

  FlutterError.onError = firebaseCrashlytics.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((List<dynamic> pair) async => await firebaseCrashlytics.recordError(
        pair.first,
        pair.last as StackTrace,
      )).sendPort);

  runZonedGuarded<void>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final imagePicker = ImagePicker();
    final fLauncherChannel = FLauncherChannel();
    final fLauncherDatabase = FLauncherDatabase();
    runApp(App(sharedPreferences, firebaseCrashlytics, imagePicker, fLauncherChannel, fLauncherDatabase));
  }, firebaseCrashlytics.recordError);
}

class App extends StatelessWidget {
  final SharedPreferences _sharedPreferences;
  final FirebaseCrashlytics _firebaseCrashlytics;
  final ImagePicker _imagePicker;
  final FLauncherChannel _fLauncherChannel;
  final FLauncherDatabase _fLauncherDatabase;

  static const MaterialColor _swatch = MaterialColor(0xFF011526, <int, Color>{
    50: Color(0xFF36A0FA),
    100: Color(0xFF067BDE),
    200: Color(0xFF045CA7),
    300: Color(0xFF033662),
    400: Color(0xFF022544),
    500: Color(0xFF011526),
    600: Color(0xFF000508),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });

  App(
    this._sharedPreferences,
    this._firebaseCrashlytics,
    this._imagePicker,
    this._fLauncherChannel,
    this._fLauncherDatabase,
  );

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WallpaperService(_imagePicker, _fLauncherChannel)),
          ChangeNotifierProvider(create: (_) => AppsService(_fLauncherChannel, _fLauncherDatabase)),
          ChangeNotifierProvider(
            create: (_) => SettingsService(_sharedPreferences, _firebaseCrashlytics),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          shortcuts: {...WidgetsApp.defaultShortcuts, LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent()},
          title: 'FLauncher',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: _swatch,
            toggleableActiveColor: _swatch[200],
            // ignore: deprecated_member_use
            accentColor: _swatch[200],
            cardColor: _swatch[300],
            dialogBackgroundColor: _swatch[400],
            canvasColor: _swatch[400],
            backgroundColor: _swatch[400],
            scaffoldBackgroundColor: _swatch[400],
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.white),
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            typography: Typography.material2018(),
          ),
          home: Builder(
            builder: (context) => WillPopScope(
              onWillPop: () => _shouldPopScope(context),
              child: FLauncher(),
            ),
          ),
        ),
      );

  Future<bool> _shouldPopScope(BuildContext context) async => !(await context.read<AppsService>().isDefaultLauncher());
}
