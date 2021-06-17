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

import 'package:flauncher/wallpaper_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mocks.dart';

void main() {
  late MockPathProviderPlatform pathProviderPlatform;
  setUpAll(() {
    pathProviderPlatform = MockPathProviderPlatform();
    when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) => Future.value("."));
    PathProviderPlatform.instance = pathProviderPlatform;
  });

  test("pickWallpaper", () async {
    final pickedFile = MockPickedFile();
    when(pickedFile.readAsBytes()).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
    final imagePicker = MockImagePicker();
    when(imagePicker.getImage(source: ImageSource.gallery)).thenAnswer((_) => Future.value(pickedFile));
    final wallpaperService = WallpaperService(imagePicker);
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.pickWallpaper();

    verify(imagePicker.getImage(source: ImageSource.gallery));
    expect(wallpaperService.wallpaperBytes, [0x01]);
  });

  test("clearWallpaper", () async {
    final wallpaperService = WallpaperService(MockImagePicker());
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.clearWallpaper();

    expect(wallpaperService.wallpaperBytes, null);
  });
}
