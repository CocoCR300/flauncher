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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text("Wallpaper"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                autofocus: true,
                onPressed: () async {
                  await _changeWallpaper();
                  Navigator.of(context).pop();
                },
                child: Text("SELECT"),
              ),
              TextButton(
                onPressed: () async {
                  await _clearWallpaper();
                  Navigator.of(context).pop();
                },
                child: Text("CLEAR"),
              ),
            ],
          ),
        ],
      );

  Future<void> _changeWallpaper() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file != null) {
      final directory = await getApplicationDocumentsDirectory();
      File(file.path).copy("${directory.path}/wallpaper");
    }
  }

  Future<void> _clearWallpaper() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/wallpaper");
    if (await file.exists()) {
      await file.delete();
    }
  }
}
