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
import 'package:flauncher/widgets/add_to_category_dialog.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/settings/applications_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../mocks.dart';
import '../../mocks.mocks.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
  });

  testWidgets("TV Applications shows TV apps", (tester) async {
    final appsService = MockAppsService();
    when(appsService.applications).thenReturn([
      fakeApp(
        packageName: "me.efesser.flauncher",
        name: "FLauncher",
        icon: kTransparentImage,
        sideloaded: false,
        hidden: false,
      )
    ]);

    await _pumpWidgetWithProviders(tester, appsService);

    expect(find.text("TV Applications"), findsOneWidget);
    expect(find.text("FLauncher"), findsOneWidget);
  });

  testWidgets("Non-TV Applications shows Non-TV apps", (tester) async {
    final appsService = MockAppsService();
    when(appsService.applications).thenReturn([
      fakeApp(
        packageName: "me.efesser.flauncher",
        name: "FLauncher",
        icon: kTransparentImage,
        sideloaded: true,
        hidden: false,
      )
    ]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text("Non-TV Applications"), findsOneWidget);
    expect(find.text("FLauncher"), findsOneWidget);
  });

  testWidgets("Hidden Applications shows hidden apps", (tester) async {
    final appsService = MockAppsService();
    when(appsService.applications).thenReturn([
      fakeApp(
        packageName: "me.efesser.flauncher",
        name: "FLauncher",
        icon: kTransparentImage,
        sideloaded: false,
        hidden: true,
      )
    ]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text("Hidden Applications"), findsOneWidget);
    expect(find.text("FLauncher"), findsOneWidget);
  });

  testWidgets("'Add' opens AddToCategoryDialog", (tester) async {
    final appsService = MockAppsService();
    final application = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.applications).thenReturn([application]);
    when(appsService.categoriesWithApps).thenReturn([CategoryWithApps(fakeCategory(), [])]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(AddToCategoryDialog), findsOneWidget);
  });

  testWidgets("'Info' opens ApplicationInfoPanel", (tester) async {
    final appsService = MockAppsService();
    final application = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.applications).thenReturn([application]);
    when(appsService.categoriesWithApps).thenReturn([CategoryWithApps(fakeCategory(), [])]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(ApplicationInfoPanel), findsOneWidget);
  });
}

Future<void> _pumpWidgetWithProviders(WidgetTester tester, AppsService appsService) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(home: ApplicationsPanelPage()),
    ),
  );
  await tester.pumpAndSettle();
}
