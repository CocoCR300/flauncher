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

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsplash_client/unsplash_client.dart';

class WallpaperService extends ChangeNotifier {
  final ImagePicker _imagePicker;
  final FLauncherChannel _fLauncherChannel;
  final UnsplashClient _unsplashClient;
  late File _wallpaperFile;

  Uint8List? _wallpaper;

  Uint8List? get wallpaperBytes => _wallpaper;

  WallpaperService(this._imagePicker, this._fLauncherChannel, this._unsplashClient) {
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
    if (!(await _fLauncherChannel.checkForGetContentAvailability())) {
      throw NoFileExplorerException();
    }
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      await _wallpaperFile.writeAsBytes(bytes);
      _wallpaper = bytes;
      notifyListeners();
    }
  }

  Future<void> random(String query) async {
    final size = window.physicalSize;
    final image =
        (await _unsplashClient.photos.random(query: query, orientation: PhotoOrientation.landscape).goAndGet()).first;
    await _unsplashClient.photos.download(image.id).goAndGet();
    final uri = image.urls.raw.resizePhoto(
      width: size.width.toInt(),
      height: size.height.toInt(),
      fit: ResizeFitMode.clip,
      format: ImageFormat.jpg,
      quality: 75,
    );
    final response = await get(uri);
    final bytes = response.bodyBytes;
    await _wallpaperFile.writeAsBytes(bytes);
    _wallpaper = bytes;
    notifyListeners();
  }

  Future<List<Photo>> search(String query) =>
      _unsplashClient.photos.random(query: query, orientation: PhotoOrientation.landscape, count: 30).goAndGet();

  Future<void> setFromUnsplash(Photo image) async {
    final size = window.physicalSize;
    await _unsplashClient.photos.download(image.id).goAndGet();
    final uri = image.urls.raw.resizePhoto(
      width: size.width.toInt(),
      height: size.height.toInt(),
      fit: ResizeFitMode.clip,
      format: ImageFormat.jpg,
      quality: 75,
    );
    final response = await get(uri);
    final bytes = response.bodyBytes;
    await _wallpaperFile.writeAsBytes(bytes);
    _wallpaper = bytes;
    notifyListeners();
  }

  Future<void> clearWallpaper() async {
    if (await _wallpaperFile.exists()) {
      await _wallpaperFile.delete();
    }
    _wallpaper = null;
    notifyListeners();
  }
}

class NoFileExplorerException implements Exception {}
