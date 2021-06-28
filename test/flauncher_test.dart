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
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/apps_grid.dart';
import 'package:flauncher/widgets/category_row.dart';
import 'package:flauncher/widgets/settings_panel_page.dart';
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

  testWidgets("Home page shows categories with apps", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    final applicationsCategory = fakeCategory("Applications", 1);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory("Favorites", 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          "me.efesser.flauncher",
          "FLauncher",
          ".MainActivity",
          "1.0.0",
          kTransparentImage,
          null,
        )
      ]),
    ]);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(find.text("Applications"), findsOneWidget);
    expect(find.text("Favorites"), findsOneWidget);
    expect(find.byType(AppsGrid), findsOneWidget);
    expect(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")), findsOneWidget);
    expect(find.byType(CategoryRow), findsOneWidget);
    expect(find.text("This category is empty.\nLong-press an app to move it here."), findsOneWidget);
    expect(tester.widget(find.byKey(Key("background"))), isA<Container>());
  });

  testWidgets("Home page displays background image", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.categoriesWithApps).thenReturn([]);
    when(wallpaperService.wallpaperBytes).thenReturn(kTransparentImage);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(tester.widget(find.byKey(Key("background"))), isA<Image>());
  });

  testWidgets("Pressing select on settings icon opens SettingsPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory("Favorites", 0), []),
      CategoryWithApps(fakeCategory("Applications", 1), []),
    ]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPanelPage), findsOneWidget);
  });

  testWidgets("Pressing select on app opens ApplicationInfoPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final app = fakeApp(
      "me.efesser.flauncher",
      "FLauncher",
      ".MainActivity",
      "1.0.0",
      kTransparentImage,
      kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory("Favorites", 0), []),
      CategoryWithApps(fakeCategory("Applications", 1), [app]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pumpAndSettle();

    verify(appsService.launchApp(app));
  });

  testWidgets("Long pressing on app opens ApplicationInfoPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final applicationsCategory = fakeCategory("Applications", 1);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory("Favorites", 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          "me.efesser.flauncher",
          "FLauncher",
          ".MainActivity",
          "1.0.0",
          kTransparentImage,
          kTransparentImage,
        )
      ]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.longPress(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")));
    await tester.pumpAndSettle();

    expect(find.byType(ApplicationInfoPanel), findsOneWidget);
  });

  testWidgets("AppCard moves", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final applicationsCategory = fakeCategory("Applications", 1);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory("Favorites", 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          "me.efesser.flauncher",
          "FLauncher",
          ".MainActivity",
          "1.0.0",
          kTransparentImage,
          kTransparentImage,
        ),
        fakeApp(
          "me.efesser.flauncher.2",
          "FLauncher 2",
          ".MainActivity",
          "1.0.0",
          kTransparentImage,
          kTransparentImage,
        )
      ]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.longPress(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    verify(appsService.reorderApplication(applicationsCategory, 0, 1));
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pumpAndSettle();
    verify(appsService.saveOrderInCategory(applicationsCategory));
  });
}

Future<void> _pumpWidgetWithProviders(
  WidgetTester tester,
  WallpaperService wallpaperService,
  AppsService appsService,
  SettingsService settingsService,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WallpaperService>.value(value: wallpaperService),
        ChangeNotifierProvider<AppsService>.value(value: appsService),
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
      ],
      builder: (_, __) => MaterialApp(
        home: FLauncher(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
