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
import 'package:flauncher/flauncher.dart';
import 'package:flauncher/gradients.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/ticker_model.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/apps_grid.dart';
import 'package:flauncher/widgets/category_row.dart';
import 'package:flauncher/widgets/settings/settings_panel_page.dart';
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
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    final favoritesCategory = fakeCategory(name: "Favorites", order: 0, type: CategoryType.row);
    final applicationsCategory = fakeCategory(name: "Applications", order: 1);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, [
        fakeApp(
          packageName: "me.efesser.flauncher.1",
          name: "FLauncher 1",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: null,
        )
      ]),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          packageName: "me.efesser.flauncher.2",
          name: "FLauncher 2",
          version: "2.0.0",
          banner: kTransparentImage,
          icon: null,
        )
      ]),
    ]);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(find.text("Applications"), findsOneWidget);
    expect(find.text("Favorites"), findsOneWidget);
    expect(find.byType(AppsGrid), findsOneWidget);
    expect(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher.2")), findsOneWidget);
    expect(find.byType(CategoryRow), findsOneWidget);
    expect(find.byKey(Key("${favoritesCategory.id}-me.efesser.flauncher.1")), findsOneWidget);
    expect(tester.widget(find.byKey(Key("background"))), isA<Container>());
  });

  testWidgets("Home page shows category empty-state", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    final applicationsCategory = fakeCategory(name: "Applications", order: 0, type: CategoryType.grid);
    final favoritesCategory = fakeCategory(name: "Favorites", order: 1, type: CategoryType.row);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(applicationsCategory, []),
      CategoryWithApps(favoritesCategory, []),
    ]);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(find.text("Applications"), findsOneWidget);
    expect(find.text("Favorites"), findsOneWidget);
    expect(find.byType(CategoryRow), findsOneWidget);
    expect(find.byType(AppsGrid), findsOneWidget);
    expect(find.text("This category is empty."), findsNWidgets(2));
  });

  testWidgets("Home page displays background image", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(appsService.categoriesWithApps).thenReturn([]);
    when(wallpaperService.wallpaperBytes).thenReturn(kTransparentImage);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(tester.widget(find.byKey(Key("background"))), isA<Image>());
  });

  testWidgets("Home page displays background gradient", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(appsService.categoriesWithApps).thenReturn([]);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);

    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    expect(tester.widget(find.byKey(Key("background"))), isA<Container>());
  });

  testWidgets("Pressing select on settings icon opens SettingsPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory(name: "Favorites", order: 0), []),
      CategoryWithApps(fakeCategory(name: "Applications", order: 1), []),
    ]);
    when(settingsService.crashReportsEnabled).thenReturn(false);
    when(settingsService.analyticsEnabled).thenReturn(false);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.byType(SettingsPanelPage), findsOneWidget);
  });

  testWidgets("Pressing select on app opens ApplicationInfoPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
      banner: kTransparentImage,
      icon: kTransparentImage,
    );
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory(name: "Favorites", order: 0), []),
      CategoryWithApps(fakeCategory(name: "Applications", order: 1), [app]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pump();

    verify(appsService.launchApp(app));
  });

  testWidgets("Long pressing on app opens ApplicationInfoPanel", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final applicationsCategory = fakeCategory(name: "Applications", order: 1);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory(name: "Favorites", order: 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: kTransparentImage,
        )
      ]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.longPress(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")));
    await tester.pump();

    expect(find.byType(ApplicationInfoPanel), findsOneWidget);
  });

  testWidgets("AppCard moves in grid", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final applicationsCategory = fakeCategory(name: "Applications", order: 1, type: CategoryType.grid);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory(name: "Favorites", order: 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: kTransparentImage,
        ),
        fakeApp(
          packageName: "me.efesser.flauncher.2",
          name: "FLauncher 2",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: kTransparentImage,
        )
      ]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.longPress(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    verify(appsService.reorderApplication(applicationsCategory, 0, 1));
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pump();
    verify(appsService.saveOrderInCategory(applicationsCategory));
  });

  testWidgets("AppCard moves in row", (tester) async {
    final wallpaperService = MockWallpaperService();
    final appsService = MockAppsService();
    final settingsService = MockSettingsService();
    when(appsService.initialized).thenReturn(true);
    when(wallpaperService.wallpaperBytes).thenReturn(null);
    when(wallpaperService.gradient).thenReturn(FLauncherGradients.greatWhale);
    when(settingsService.use24HourTimeFormat).thenReturn(false);
    final applicationsCategory = fakeCategory(name: "Applications", order: 1, type: CategoryType.row);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(fakeCategory(name: "Favorites", order: 0), []),
      CategoryWithApps(applicationsCategory, [
        fakeApp(
          packageName: "me.efesser.flauncher",
          name: "FLauncher",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: kTransparentImage,
        ),
        fakeApp(
          packageName: "me.efesser.flauncher.2",
          name: "FLauncher 2",
          version: "1.0.0",
          banner: kTransparentImage,
          icon: kTransparentImage,
        )
      ]),
    ]);
    await _pumpWidgetWithProviders(tester, wallpaperService, appsService, settingsService);

    await tester.longPress(find.byKey(Key("${applicationsCategory.id}-me.efesser.flauncher")));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    verify(appsService.reorderApplication(applicationsCategory, 0, 1));
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pump();
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
        Provider<TickerModel>(create: (_) => TickerModel(tester))
      ],
      builder: (_, __) => MaterialApp(
        home: FLauncher(),
      ),
    ),
  );
  await tester.pump(Duration(seconds: 30), EnginePhase.sendSemanticsUpdate);
}
