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

import 'package:flauncher/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'mocks.mocks.dart';

void main() {
  setUp(() {
    SharedPreferencesStorePlatform.instance = InMemorySharedPreferencesStore.empty();
  });

  test("setCrashReportsEnabled", () async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final firebaseCrashlytics = MockFirebaseCrashlytics();
    final settingsService = SettingsService(sharedPreferences, firebaseCrashlytics);
    await untilCalled(firebaseCrashlytics.setCrashlyticsCollectionEnabled(any));

    await settingsService.setCrashReportsEnabled(true);

    verify(firebaseCrashlytics.setCrashlyticsCollectionEnabled(false)).called(2);
    expect(sharedPreferences.getBool("crash_reports_enabled"), isTrue);
  });
}
