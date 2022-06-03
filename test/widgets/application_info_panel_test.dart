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

import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
  });

  testWidgets("'Open' calls launchApp on AppsService", (tester) async {
    final appsService = MockAppsService();
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.applications).thenReturn([app]);
    await _pumpWidgetWithProviders(tester, appsService, null, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(appsService.launchApp(app));
  });

  testWidgets("'Hide' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.hideApplication(app));
  });

  testWidgets("'Remove from...' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.removeFromCategory(app, category));
  });

  testWidgets("'App info' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.openAppInfo(app));
  });

  testWidgets("'Uninstall' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.uninstallApp(app));
  });
}

Future<void> _pumpWidgetWithProviders(
  WidgetTester tester,
  AppsService appsService,
  Category? category,
  App application,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(
        home: ApplicationInfoPanel(
          category: category,
          application: application,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
