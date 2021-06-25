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

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _crashReportsEnabledKey = "crash_reports_enabled";
const _appCardFocusEffectKey = "app_card_focus_effect";

class SettingsService extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  final FirebaseCrashlytics _firebaseCrashlytics;

  bool get crashReportsEnabled => _sharedPreferences.getBool(_crashReportsEnabledKey) ?? true;

  FocusEffect get focusEffect => FocusEffectConversion.fromString(_sharedPreferences.getString(_appCardFocusEffectKey));

  SettingsService(this._sharedPreferences, this._firebaseCrashlytics) {
    _firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode && crashReportsEnabled);
  }

  Future<void> setCrashReportsEnabled(bool value) async {
    _firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode && value);
    await _sharedPreferences.setBool(_crashReportsEnabledKey, value);
    notifyListeners();
  }

  Future<void> setFocusEffect(FocusEffect value) async {
    await _sharedPreferences.setString(_appCardFocusEffectKey, value.toShortString());
    notifyListeners();
  }
}

enum FocusEffect { zoom, glow }

extension FocusEffectConversion on FocusEffect {
  static FocusEffect fromString(String? value) {
    switch (value) {
      case "zoom":
        return FocusEffect.zoom;
      case "glow":
        return FocusEffect.glow;
      default:
        return FocusEffect.zoom;
    }
  }

  String toShortString() {
    switch (this) {
      case FocusEffect.zoom:
        return "zoom";
      case FocusEffect.glow:
        return "glow";
      default:
        return "zoom";
    }
  }
}
