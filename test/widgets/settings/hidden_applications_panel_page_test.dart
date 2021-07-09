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
import 'package:flauncher/widgets/settings/hidden_applications_panel_page.dart';
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
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.window.textScaleFactorTestValue = 0.8;
  });

  testWidgets("No hidden applications shows empty state", (tester) async {
    final appsService = MockAppsService();
    when(appsService.hiddenApplications).thenReturn([]);

    await _pumpWidgetWithProviders(tester, appsService);

    expect(find.text("Nothing to see here."), findsOneWidget);
  });

  testWidgets("'Open' launches the application", (tester) async {
    final appsService = MockAppsService();
    final application = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.hiddenApplications).thenReturn([application]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(appsService.launchApp(application));
  });

  testWidgets("'Unhide' unhides the application", (tester) async {
    final appsService = MockAppsService();
    final application = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.hiddenApplications).thenReturn([application]);

    await _pumpWidgetWithProviders(tester, appsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    verify(appsService.unHideApplication(application));
  });
}

Future<void> _pumpWidgetWithProviders(WidgetTester tester, AppsService appsService) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(home: HiddenApplicationsPanelPage()),
    ),
  );
  await tester.pumpAndSettle();
}
