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
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flauncher_app.dart';

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
    runApp(FLauncherApp(sharedPreferences, firebaseCrashlytics, imagePicker, fLauncherChannel, fLauncherDatabase));
  }, firebaseCrashlytics.recordError);
}
