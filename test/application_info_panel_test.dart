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

import 'package:flauncher/apps_service.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/move_to_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'mocks.dart';
import 'mocks.mocks.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.window.textScaleFactorTestValue = 0.8;
  });

  testWidgets("'Move to...' opens MoveToCategoryDialog and sends its result to AppsService", (tester) async {
    final appsService = MockAppsService();
    final category1 = fakeCategory("Category 1", 0);
    final category2 = fakeCategory("Category 2", 1);
    final app = fakeApp(
      "me.efesser.flauncher",
      "FLauncher",
      ".MainActivity",
      "1.0.0",
      kTransparentImage,
      kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category1, [app]),
      CategoryWithApps(category2, []),
    ]);
    await _pumpWidgetWithProviders(tester, appsService, category1, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(MoveToCategoryDialog), findsOneWidget);
    expect(find.text("Category 1"), findsNothing);
    expect(find.text("Category 2"), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.moveToCategory(app, category1, category2));
  });

  testWidgets("'App info' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory("Category 1", 0);
    final app = fakeApp(
      "me.efesser.flauncher",
      "FLauncher",
      ".MainActivity",
      "1.0.0",
      kTransparentImage,
      kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(appsService.openAppInfo(app));
  });

  testWidgets("'Uninstall' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory("Category 1", 0);
    final app = fakeApp(
      "me.efesser.flauncher",
      "FLauncher",
      ".MainActivity",
      "1.0.0",
      kTransparentImage,
      kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(category, [app]),
    ]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

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
  Category category,
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
