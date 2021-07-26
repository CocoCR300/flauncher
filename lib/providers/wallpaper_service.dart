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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/gradients.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/unsplash_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperService extends ChangeNotifier {
  final ImagePicker _imagePicker;
  final FLauncherChannel _fLauncherChannel;
  final UnsplashService _unsplashService;
  late SettingsService _settingsService;

  late final File _wallpaperFile;
  Uint8List? _wallpaper;

  Uint8List? get wallpaperBytes => _wallpaper;

  FLauncherGradient get gradient => FLauncherGradients.all.firstWhere(
        (gradient) => gradient.uuid == _settingsService.gradientUuid,
        orElse: () => FLauncherGradients.greatWhale,
      );

  set settingsService(SettingsService settingsService) => _settingsService = settingsService;

  WallpaperService(this._imagePicker, this._fLauncherChannel, this._unsplashService) {
    _init();
  }

  Future<void> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    _wallpaperFile = File("${directory.path}/wallpaper");
    if (await _wallpaperFile.exists()) {
      _wallpaper = await _wallpaperFile.readAsBytes();
      notifyListeners();
    }
  }

  Future<void> pickWallpaper() async {
    if (!await _fLauncherChannel.checkForGetContentAvailability()) {
      throw NoFileExplorerException();
    }
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      await _wallpaperFile.writeAsBytes(bytes);
      _wallpaper = bytes;
      await _settingsService.setUnsplashAuthor(null);
      notifyListeners();
    }
  }

  Future<void> randomFromUnsplash(String query) async {
    final photo = await _unsplashService.randomPhoto(query);
    final bytes = await _unsplashService.downloadPhoto(photo);
    await _wallpaperFile.writeAsBytes(bytes);
    _wallpaper = bytes;
    await _settingsService
        .setUnsplashAuthor(jsonEncode({"username": photo.username, "link": photo.userLink.toString()}));
    notifyListeners();
  }

  Future<List<Photo>> searchFromUnsplash(String query) => _unsplashService.searchPhotos(query);

  Future<void> setFromUnsplash(Photo photo) async {
    final bytes = await _unsplashService.downloadPhoto(photo);
    await _wallpaperFile.writeAsBytes(bytes);
    _wallpaper = bytes;
    await _settingsService
        .setUnsplashAuthor(jsonEncode({"username": photo.username, "link": photo.userLink.toString()}));
    notifyListeners();
  }

  Future<void> setGradient(FLauncherGradient fLauncherGradient) async {
    if (await _wallpaperFile.exists()) {
      await _wallpaperFile.delete();
    }
    _wallpaper = null;
    _settingsService.setUnsplashAuthor(null);
    _settingsService.setGradientUuid(fLauncherGradient.uuid);
    notifyListeners();
  }
}

class NoFileExplorerException implements Exception {}
