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
import 'package:flauncher/widgets/add_category_dialog.dart';
import 'package:flauncher/widgets/settings/category_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

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

  testWidgets("Category is displayed", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.grid, columnsCount: 6);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    expect(find.text("Favorites"), findsNWidgets(2));
    expect(find.text("Alphabetical"), findsOneWidget);
    expect(find.text("Grid"), findsOneWidget);
    expect(find.text("6"), findsOneWidget);
  });

  testWidgets("'Edit name' opens AddCategoryDialog", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.grid, columnsCount: 6);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.byType(AddCategoryDialog), findsOneWidget);
  });

  testWidgets("'Sort' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.grid, columnsCount: 6);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    verify(appsService.setCategorySort(favoritesCategory, CategorySort.manual));
  });

  testWidgets("'Type' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.row, rowHeight: 110);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    verify(appsService.setCategoryType(favoritesCategory, CategoryType.grid));
  });

  testWidgets("'Columns count' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.grid, columnsCount: 6);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    verify(appsService.setCategoryColumnsCount(favoritesCategory, 7));
  });

  testWidgets("'Row height' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.row, rowHeight: 110);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    verify(appsService.setCategoryRowHeight(favoritesCategory, 120));
  });

  testWidgets("'Delete' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final favoritesCategory =
        fakeCategory(name: "Favorites", sort: CategorySort.alphabetical, type: CategoryType.row, rowHeight: 110);
    when(appsService.categoriesWithApps).thenReturn([
      CategoryWithApps(favoritesCategory, []),
      CategoryWithApps(fakeCategory(name: "Applications"), []),
    ]);

    await _pumpWidgetWithProviders(tester, appsService, favoritesCategory.id);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    verify(appsService.deleteCategory(favoritesCategory));
  });
}

Future<void> _pumpWidgetWithProviders(WidgetTester tester, AppsService appsService, int categoryId) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(
        home: Scaffold(body: CategoryPanelPage(categoryId: categoryId)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
