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

import 'dart:ui';

import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/widgets/categories_dialog.dart';
import 'package:flauncher/widgets/flauncher_about_dialog.dart';
import 'package:flauncher/widgets/settings_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider/provider.dart';

import 'mocks.mocks.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.window.textScaleFactorTestValue = 0.8;
  });

  testWidgets("'Categories' opens CategoriesDialog", (tester) async {
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesDialog), findsOneWidget);
  });

  testWidgets("'Android settings' calls AppsService", (tester) async {
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(appsService.openSettings());
  });

  testWidgets("'Use 24-hour time format' toggle calls SettingsService", (tester) async {
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(settingsService.setUse24HourTimeFormat(true));
  });

  testWidgets("'Crash Reporting' toggle calls SettingsService", (tester) async {
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(settingsService.setCrashReportsEnabled(true));
  });

  testWidgets("'About FLauncher' opens ", (tester) async {
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    PackageInfo.disablePackageInfoPlatformOverride = true;
    PackageInfoPlatform.instance = _MockPackageInfoPlatform();

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(FLauncherAboutDialog), findsOneWidget);
  });
}

Future<void> _pumpWidgetWithProviders(
  WidgetTester tester,
  SettingsService settingsService,
  AppsService appsService,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(
        home: SettingsPanelPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MockPackageInfoPlatform with MockPlatformInterfaceMixin implements PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll() async => PackageInfoData(
        appName: "FLauncher",
        packageName: "me.efesser.flauncher",
        version: "1.0.0",
        buildNumber: "1",
      );
}
