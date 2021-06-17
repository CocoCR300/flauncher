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

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

@GenerateMocks([
  FLauncherChannel,
  FLauncherDatabase,
  FirebaseCrashlytics,
])
void main() {}

App fakeApp([
  String packageName = "me.efesser.flauncher",
  String name = "FLauncher",
  String className = "",
  String version = "1.0.0",
  Uint8List? banner,
  Uint8List? icon,
]) =>
    App(packageName: packageName, name: name, className: className, version: version, banner: banner, icon: icon);

Category fakeCategory([String name = "Favorites", int order = 0]) => Category(name: name, order: order);

class MockImagePicker extends Mock implements ImagePicker {
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
class MockPickedFile extends Mock implements PickedFile {
  @override
  Future<Uint8List> readAsBytes() => super
      .noSuchMethod(Invocation.method(#readAsBytes, []), returnValue: Future<Uint8List>.value(Uint8List.fromList([])));
}

class MockPathProviderPlatform extends Mock with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() =>
      super.noSuchMethod(Invocation.method(#getApplicationDocumentsPath, []), returnValue: Future<String?>.value());
}
