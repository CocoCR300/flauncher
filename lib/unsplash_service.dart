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
import 'package:unsplash_client/unsplash_client.dart' as unsplash;

class UnsplashService {
  final unsplash.UnsplashClient _unsplashClient;

  UnsplashService(this._unsplashClient);

  Future<Photo> randomPhoto(String query) async =>
      (await _unsplashClient.photos.random(query: query, orientation: unsplash.PhotoOrientation.landscape).goAndGet())
          .map(_buildPhoto)
          .first;

  Future<List<Photo>> searchPhotos(String query) async => (await _unsplashClient.photos
          .random(query: query, orientation: unsplash.PhotoOrientation.landscape, count: 30)
          .goAndGet())
      .map(_buildPhoto)
      .toList();

  Future<Uint8List> downloadPhoto(Photo photo) => _downloadResized(photo);

  Future<Uint8List> _downloadResized(Photo photo) async {
    final size = window.physicalSize;
    await _unsplashClient.photos.download(photo.id).goAndGet();
    final uri = photo.raw.resizePhoto(
      width: size.width.toInt(),
      height: size.height.toInt(),
      fit: unsplash.ResizeFitMode.clip,
      format: unsplash.ImageFormat.jpg,
      quality: 75,
    );
    final response = await get(uri);
    return response.bodyBytes;
  }

  Photo _buildPhoto(unsplash.Photo photo) => Photo(photo.id, photo.user.name, photo.urls.small, photo.urls.raw,
      photo.user.links.html.replace(queryParameters: {"utm_source": "flauncher", "utm_medium": "referral"}));
}

class Photo {
  final String id;
  final String username;
  final Uri small;
  final Uri raw;
  final Uri userLink;

  Photo(this.id, this.username, this.small, this.raw, this.userLink);
}
