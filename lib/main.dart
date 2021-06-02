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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flauncher/apps.dart';
import 'package:flauncher/flauncher.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/wallpaper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  Isolate.current.addErrorListener(RawReceivePort((List<dynamic> pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last as StackTrace,
    );
  }).sendPort);

  runZonedGuarded<void>(() {
    runApp(App());
  }, FirebaseCrashlytics.instance.recordError);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(create: (_) => ImagePicker()),
          ChangeNotifierProvider(create: (_) => Wallpaper()),
          ChangeNotifierProvider(create: (_) => Apps(FLauncherChannel()))
        ],
        child: MaterialApp(
          shortcuts: WidgetsApp.defaultShortcuts
            ..addAll(
                {LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent()}),
          title: 'FLauncher',
          theme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: Colors.white),
            typography: Typography.material2018(),
            buttonTheme: ButtonThemeData(highlightColor: Colors.transparent),
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: Builder(
            builder: (context) => WillPopScope(
              onWillPop: () => _shouldPopScope(context),
              child: FLauncher(),
            ),
          ),
        ),
      );

  Future<bool> _shouldPopScope(BuildContext context) async =>
      !(await context.read<Apps>().isDefaultLauncher());
}
