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

import 'package:flauncher/gradients.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/unsplash_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/drift.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../mocks.mocks.dart';

void main() {
  late final _MockPathProviderPlatform pathProviderPlatform;
  setUpAll(() {
    pathProviderPlatform = _MockPathProviderPlatform();
    when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) => Future.value("."));
    PathProviderPlatform.instance = pathProviderPlatform;
  });

  group("pickWallpaper", () {
    test("picks image", () async {
      final pickedFile = _MockXFile();
      when(pickedFile.readAsBytes()).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
      final imagePicker = _MockImagePicker();
      final fLauncherChannel = MockFLauncherChannel();
      final settingsService = MockSettingsService();
      when(imagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) => Future.value(pickedFile));
      when(fLauncherChannel.checkForGetContentAvailability()).thenAnswer((_) => Future.value(true));
      final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, MockUnsplashService())
        ..settingsService = settingsService;
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      await wallpaperService.pickWallpaper();

      verify(imagePicker.pickImage(source: ImageSource.gallery));
      verify(settingsService.setUnsplashAuthor(null));
      expect(wallpaperService.wallpaperBytes, [0x01]);
    });

    test("throws error when no file explorer installed", () async {
      final fLauncherChannel = MockFLauncherChannel();
      when(fLauncherChannel.checkForGetContentAvailability()).thenAnswer((_) => Future.value(false));
      final wallpaperService = WallpaperService(_MockImagePicker(), fLauncherChannel, MockUnsplashService());
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      expect(() async => await wallpaperService.pickWallpaper(), throwsA(isInstanceOf<NoFileExplorerException>()));
    });
  });

  test("randomFromUnsplash", () async {
    final imagePicker = _MockImagePicker();
    final fLauncherChannel = MockFLauncherChannel();
    final unsplashService = MockUnsplashService();
    final settingsService = MockSettingsService();
    final photo = Photo(
      "e07ebff3-0b4d-4e0a-ae94-97ef32bd59e6",
      "John Doe",
      Uri.parse("http://localhost/small.jpg"),
      Uri.parse("http://localhost/raw.jpg"),
      Uri.parse("http://localhost/@author"),
    );
    when(unsplashService.randomPhoto("test")).thenAnswer((_) => Future.value(photo));
    when(unsplashService.downloadPhoto(photo)).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
    final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService)
      ..settingsService = settingsService;
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.randomFromUnsplash("test");

    verify(unsplashService.randomPhoto("test"));
    verify(settingsService.setUnsplashAuthor('{"username":"John Doe","link":"http://localhost/@author"}'));
    expect(wallpaperService.wallpaperBytes, [0x01]);
  });

  test("searchFromUnsplash", () async {
    final imagePicker = _MockImagePicker();
    final fLauncherChannel = MockFLauncherChannel();
    final unsplashService = MockUnsplashService();
    final photo = Photo(
      "e07ebff3-0b4d-4e0a-ae94-97ef32bd59e6",
      "Username",
      Uri.parse("http://localhost/small.jpg"),
      Uri.parse("http://localhost/raw.jpg"),
      Uri.parse("http://localhost/@author"),
    );
    when(unsplashService.searchPhotos("test")).thenAnswer((_) => Future.value([photo]));
    final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService);
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    final photos = await wallpaperService.searchFromUnsplash("test");

    expect(photos, [photo]);
  });

  test("setFromUnsplash", () async {
    final imagePicker = _MockImagePicker();
    final fLauncherChannel = MockFLauncherChannel();
    final unsplashService = MockUnsplashService();
    final settingsService = MockSettingsService();
    final photo = Photo(
      "e07ebff3-0b4d-4e0a-ae94-97ef32bd59e6",
      "John Doe",
      Uri.parse("http://localhost/small.jpg"),
      Uri.parse("http://localhost/raw.jpg"),
      Uri.parse("http://localhost/@author"),
    );
    when(unsplashService.downloadPhoto(photo)).thenAnswer((_) => Future.value(Uint8List.fromList([0x01])));
    final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService)
      ..settingsService = settingsService;
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.setFromUnsplash(photo);

    verify(unsplashService.downloadPhoto(photo));
    verify(settingsService.setUnsplashAuthor('{"username":"John Doe","link":"http://localhost/@author"}'));
    expect(wallpaperService.wallpaperBytes, [0x01]);
  });

  test("setGradient", () async {
    final imagePicker = _MockImagePicker();
    final fLauncherChannel = MockFLauncherChannel();
    final unsplashService = MockUnsplashService();
    final settingsService = MockSettingsService();
    final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService)
      ..settingsService = settingsService;
    await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

    await wallpaperService.setGradient(FLauncherGradients.greatWhale);

    verify(settingsService.setGradientUuid(FLauncherGradients.greatWhale.uuid));
    verify(settingsService.setUnsplashAuthor(null));
    expect(wallpaperService.wallpaperBytes, null);
  });

  group("getGradient", () {
    test("without uuid from settings", () async {
      final imagePicker = _MockImagePicker();
      final fLauncherChannel = MockFLauncherChannel();
      final unsplashService = MockUnsplashService();
      final settingsService = MockSettingsService();
      when(settingsService.gradientUuid).thenReturn(null);
      final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService)
        ..settingsService = settingsService;
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      final gradient = wallpaperService.gradient;

      expect(gradient, FLauncherGradients.greatWhale);
    });

    test("with uuid from settings", () async {
      final imagePicker = _MockImagePicker();
      final fLauncherChannel = MockFLauncherChannel();
      final unsplashService = MockUnsplashService();
      final settingsService = MockSettingsService();
      when(settingsService.gradientUuid).thenReturn(FLauncherGradients.grassShampoo.uuid);
      final wallpaperService = WallpaperService(imagePicker, fLauncherChannel, unsplashService)
        ..settingsService = settingsService;
      await untilCalled(pathProviderPlatform.getApplicationDocumentsPath());

      final gradient = wallpaperService.gradient;

      expect(gradient, FLauncherGradients.grassShampoo);
    });
  });
}

class _MockImagePicker extends Mock implements ImagePicker {
  @override
  Future<XFile?> pickImage(
          {required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear}) =>
      super.noSuchMethod(
          Invocation.method(#pickImage, [], {
            #source: source,
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #preferredCameraDevice: preferredCameraDevice
          }),
          returnValue: Future<XFile?>.value());
}

// ignore: must_be_immutable
class _MockXFile extends Mock implements XFile {
  @override
  Future<Uint8List> readAsBytes() => super
      .noSuchMethod(Invocation.method(#readAsBytes, []), returnValue: Future<Uint8List>.value(Uint8List.fromList([])));
}

class _MockPathProviderPlatform extends Mock with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() =>
      super.noSuchMethod(Invocation.method(#getApplicationDocumentsPath, []), returnValue: Future<String?>.value());
}
