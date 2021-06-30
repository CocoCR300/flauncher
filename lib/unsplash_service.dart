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

import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashService {
  final UnsplashClient _unsplashClient;

  UnsplashService(this._unsplashClient);

  Future<Uint8List> randomPhoto(String query) async {
    final photo =
        (await _unsplashClient.photos.random(query: query, orientation: PhotoOrientation.landscape).goAndGet()).first;
    return _downloadResized(Photo(photo.id, photo.user.name, photo.urls.small, photo.urls.raw));
  }

  Future<List<Photo>> searchPhotos(String query) async =>
      (await _unsplashClient.photos.random(query: query, orientation: PhotoOrientation.landscape, count: 30).goAndGet())
          .map((e) => Photo(e.id, e.user.name, e.urls.small, e.urls.raw))
          .toList();

  Future<Uint8List> downloadPhoto(Photo photo) => _downloadResized(photo);

  Future<Uint8List> _downloadResized(Photo photo) async {
    final size = window.physicalSize;
    await _unsplashClient.photos.download(photo.id).goAndGet();
    final uri = photo.raw.resizePhoto(
      width: size.width.toInt(),
      height: size.height.toInt(),
      fit: ResizeFitMode.clip,
      format: ImageFormat.jpg,
      quality: 75,
    );
    final response = await get(uri);
    return response.bodyBytes;
  }
}

class Photo {
  final String id;
  final String username;
  final Uri small;
  final Uri raw;

  Photo(this.id, this.username, this.small, this.raw);
}
