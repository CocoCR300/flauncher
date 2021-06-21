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
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mocks.mocks.dart';

void main() {
  late _MockPathProviderPlatform pathProviderPlatform;
  setUpAll(() {
    pathProviderPlatform = _MockPathProviderPlatform();
    when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) => Future.value("."));
    PathProviderPlatform.instance = pathProviderPlatform;
  });

  group("pickWallpaper", () {
    test("picks image", () async {
      final pickedFile = _MockPickedFile();
      when(pickedFile.readAsBytes()).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
      final imagePicker = _MockImagePicker();
      final fLauncherChannel = MockFLauncherChannel();
      when(imagePicker.getImage(source: ImageSource.gallery)).thenAnswer((_) => Future.value(pickedFile));
      when(fLauncherChannel.checkForGetContentAvailability()).thenAnswer((_) => Future.value(true));
      final wallpaperService = WallpaperService(imagePicker, fLauncherChannel);
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      await wallpaperService.pickWallpaper();

      verify(imagePicker.getImage(source: ImageSource.gallery));
      expect(wallpaperService.wallpaperBytes, [0x01]);
    });

    test("throws error when no file explorer installed", () async {
      final pickedFile = _MockPickedFile();
      when(pickedFile.readAsBytes()).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
      final imagePicker = _MockImagePicker();
      final fLauncherChannel = MockFLauncherChannel();
      when(imagePicker.getImage(source: ImageSource.gallery)).thenAnswer((_) => Future.value(pickedFile));
      when(fLauncherChannel.checkForGetContentAvailability()).thenAnswer((_) => Future.value(false));
      final wallpaperService = WallpaperService(imagePicker, fLauncherChannel);
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      expect(() async => await wallpaperService.pickWallpaper(), throwsA(isInstanceOf<NoFileExplorerException>()));
    });
  });

  test("clearWallpaper", () async {
    final wallpaperService = WallpaperService(_MockImagePicker(), MockFLauncherChannel());
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.clearWallpaper();

    expect(wallpaperService.wallpaperBytes, null);
  });
}

class _MockImagePicker extends Mock implements ImagePicker {
  @override
  Future<PickedFile?> getImage(
          {required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear}) =>
      super.noSuchMethod(
          Invocation.method(#getImage, [], {
            #source: source,
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #preferredCameraDevice: preferredCameraDevice
          }),
          returnValue: Future<PickedFile?>.value());

  @override
  Future<LostData> getLostData() => super.noSuchMethod(Invocation.method(#getLostData, []));

  @override
  Future<PickedFile?> getVideo(
          {required ImageSource source,
          CameraDevice preferredCameraDevice = CameraDevice.rear,
          Duration? maxDuration}) =>
      super.noSuchMethod(
          Invocation.method(#getVideo, [],
              {#source: source, #preferredCameraDevice: preferredCameraDevice, #maxDuration: maxDuration}),
          returnValue: Future<PickedFile?>.value());
}

// ignore: must_be_immutable
class _MockPickedFile extends Mock implements PickedFile {
  @override
  Future<Uint8List> readAsBytes() => super
      .noSuchMethod(Invocation.method(#readAsBytes, []), returnValue: Future<Uint8List>.value(Uint8List.fromList([])));
}

class _MockPathProviderPlatform extends Mock with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() =>
      super.noSuchMethod(Invocation.method(#getApplicationDocumentsPath, []), returnValue: Future<String?>.value());
}
