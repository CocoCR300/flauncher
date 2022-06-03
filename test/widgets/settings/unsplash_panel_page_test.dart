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

import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/unsplash_service.dart';
import 'package:flauncher/widgets/settings/unsplash_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../mocks.mocks.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = Size(1280, 720);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Scale-down the font size because the font 'Ahem' used when running tests is much wider than Roboto
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
  });

  testWidgets("Selecting an Unsplash category calls WallpaperService", (tester) async {
    final wallpaperService = MockWallpaperService();

    await _pumpWidgetWithProviders(tester, wallpaperService);

    expect(find.text("Landscape"), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    verify(wallpaperService.randomFromUnsplash("landscape wallpaper"));
  });

  testWidgets("Searching on Unsplash shows results and calls WallpaperService on selection", (tester) async {
    mockNetworkImagesFor(() async {
      final wallpaperService = MockWallpaperService();
      final photo = Photo(
        "e07ebff3-0b4d-4e0a-ae94-97ef32bd59e6",
        "Username",
        Uri.parse("http://localhost/small.jpg"),
        Uri.parse("http://localhost/raw.jpg"),
        Uri.parse("http://localhost/@author"),
      );
      when(wallpaperService.searchFromUnsplash("cat")).thenAnswer((_) => Future.value([photo]));

      await _pumpWidgetWithProviders(tester, wallpaperService);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), "cat");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(find.text("Username"), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      verify(wallpaperService.setFromUnsplash(photo));
    });
  });
}

Future<void> _pumpWidgetWithProviders(WidgetTester tester, WallpaperService wallpaperService) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WallpaperService>.value(value: wallpaperService),
      ],
      builder: (_, __) => MaterialApp(home: Material(child: UnsplashPanelPage())),
    ),
  );
  await tester.pumpAndSettle();
}
