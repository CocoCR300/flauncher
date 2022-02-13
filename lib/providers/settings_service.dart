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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _crashReportsEnabledKey = "crash_reports_enabled";
const _analyticsEnabledKey = "analytics_enabled";
const _use24HourTimeFormatKey = "use_24_hour_time_format";
const _gradientUuidKey = "gradient_uuid";
const _unsplashEnabledKey = "unsplash_enabled";
const _unsplashAuthorKey = "unsplash_author";

class SettingsService extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  final FirebaseCrashlytics _firebaseCrashlytics;
  final FirebaseAnalytics _firebaseAnalytics;
  final FirebaseRemoteConfig _firebaseRemoteConfig;
  late final Timer _remoteConfigRefreshTimer;

  bool get crashReportsEnabled => _sharedPreferences.getBool(_crashReportsEnabledKey) ?? true;

  bool get analyticsEnabled => _sharedPreferences.getBool(_analyticsEnabledKey) ?? true;

  bool get use24HourTimeFormat => _sharedPreferences.getBool(_use24HourTimeFormatKey) ?? true;

  String? get gradientUuid => _sharedPreferences.getString(_gradientUuidKey);

  bool get unsplashEnabled => _firebaseRemoteConfig.getBool(_unsplashEnabledKey);

  String? get unsplashAuthor => _sharedPreferences.getString(_unsplashAuthorKey);

  SettingsService(
    this._sharedPreferences,
    this._firebaseCrashlytics,
    this._firebaseAnalytics,
    this._firebaseRemoteConfig,
  ) {
    _firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode && crashReportsEnabled);
    _firebaseAnalytics.setAnalyticsCollectionEnabled(kReleaseMode && analyticsEnabled);
    _remoteConfigRefreshTimer = Timer.periodic(Duration(hours: 6, minutes: 1), (_) => _refreshFirebaseRemoteConfig());
  }

  @override
  void dispose() {
    _remoteConfigRefreshTimer.cancel();
    super.dispose();
  }

  Future<void> setCrashReportsEnabled(bool value) async {
    _firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode && value);
    await _sharedPreferences.setBool(_crashReportsEnabledKey, value);
    notifyListeners();
  }

  Future<void> setAnalyticsEnabled(bool value) async {
    _firebaseAnalytics.setAnalyticsCollectionEnabled(kReleaseMode && value);
    await _sharedPreferences.setBool(_analyticsEnabledKey, value);
    notifyListeners();
  }

  Future<void> setUse24HourTimeFormat(bool value) async {
    await _sharedPreferences.setBool(_use24HourTimeFormatKey, value);
    notifyListeners();
  }

  Future<void> setGradientUuid(String value) async {
    await _sharedPreferences.setString(_gradientUuidKey, value);
    notifyListeners();
  }

  Future<void> setUnsplashAuthor(String? value) async {
    if (value == null) {
      await _sharedPreferences.remove(_unsplashAuthorKey);
    } else {
      await _sharedPreferences.setString(_unsplashAuthorKey, value);
    }
    notifyListeners();
  }

  Future<void> _refreshFirebaseRemoteConfig() async {
    bool updated = false;
    try {
      updated = await _firebaseRemoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("Could not refresh Firebase Remote Config: $e");
    }
    if (updated) {
      notifyListeners();
    }
  }
}
