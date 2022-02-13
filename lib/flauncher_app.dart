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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flauncher/actions.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/ticker_model.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/unsplash_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'flauncher.dart';
import 'flauncher_channel.dart';

class FLauncherApp extends StatelessWidget {
  final SharedPreferences _sharedPreferences;
  final FirebaseCrashlytics _firebaseCrashlytics;
  final FirebaseAnalytics _firebaseAnalytics;
  final ImagePicker _imagePicker;
  final FLauncherChannel _fLauncherChannel;
  final FLauncherDatabase _fLauncherDatabase;
  final UnsplashService _unsplashService;
  final FirebaseRemoteConfig _firebaseRemoteConfig;

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

  FLauncherApp(
    this._sharedPreferences,
    this._firebaseCrashlytics,
    this._firebaseAnalytics,
    this._imagePicker,
    this._fLauncherChannel,
    this._fLauncherDatabase,
    this._unsplashService,
    this._firebaseRemoteConfig,
  );

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) =>
                  SettingsService(_sharedPreferences, _firebaseCrashlytics, _firebaseAnalytics, _firebaseRemoteConfig),
              lazy: false),
          ChangeNotifierProvider(create: (_) => AppsService(_fLauncherChannel, _fLauncherDatabase)),
          ChangeNotifierProxyProvider<SettingsService, WallpaperService>(
              create: (_) => WallpaperService(_imagePicker, _fLauncherChannel, _unsplashService),
              update: (_, settingsService, wallpaperService) => wallpaperService!..settingsService = settingsService),
          Provider<TickerModel>(create: (context) => TickerModel(null))
        ],
        child: MaterialApp(
          shortcuts: {
            ...WidgetsApp.defaultShortcuts,
            SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.gameButtonB): PrioritizedIntents(orderedIntents: [
              DismissIntent(),
              BackIntent(),
            ]),
          },
          actions: {
            ...WidgetsApp.defaultActions,
            DirectionalFocusIntent: SoundFeedbackDirectionalFocusAction(context),
          },
          title: 'FLauncher',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: _swatch,
            toggleableActiveColor: _swatch[200],
            // ignore: deprecated_member_use
            accentColor: _swatch[200],
            cardColor: _swatch[300],
            canvasColor: _swatch[300],
            dialogBackgroundColor: _swatch[400],
            backgroundColor: _swatch[400],
            scaffoldBackgroundColor: _swatch[400],
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white)),
            appBarTheme: AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
            typography: Typography.material2018(),
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              labelStyle: Typography.material2018().white.bodyText2,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: _swatch[200],
              selectionHandleColor: _swatch[200],
            ),
          ),
          home: Builder(
            builder: (context) => WillPopScope(
              onWillPop: () async {
                final shouldPop = await shouldPopScope(context);
                if (!shouldPop) {
                  context.read<AppsService>().startAmbientMode();
                }
                return shouldPop;
              },
              child: Actions(actions: {BackIntent: BackAction(context, systemNavigator: true)}, child: FLauncher()),
            ),
          ),
        ),
      );
}
