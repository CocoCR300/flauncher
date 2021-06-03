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

import 'package:flauncher/apps.dart';
import 'package:flauncher/wallpaper.dart';
import 'package:flauncher/widgets/right_panel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RightPanelDialog(
        child: Column(
          children: [
            Text(
              "Settings",
              style: Theme.of(context).textTheme.headline6,
            ),
            Divider(),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.wallpaper_outlined),
                  Container(width: 8),
                  Text(
                    "Wallpaper",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => _WallpaperDialog(),
              ),
            ),
            Divider(),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.settings_outlined),
                  Container(width: 8),
                  Text(
                    "Android settings",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              onPressed: () => context.read<Apps>().openSettings(),
            ),
          ],
        ),
      );
}

class _WallpaperDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text("Wallpaper"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                autofocus: true,
                onPressed: () => _pickFile(context),
                child: Text("SELECT"),
              ),
              TextButton(
                onPressed: () => _clearWallpaper(context),
                child: Text("CLEAR"),
              ),
            ],
          ),
        ],
      );

  Future<void> _pickFile(BuildContext context) async {
    final imagePicker = context.read<ImagePicker>();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      context.read<Wallpaper>().setWallpaper(bytes);
    }
    Navigator.of(context).pop();
  }

  Future<void> _clearWallpaper(BuildContext context) async {
    await context.read<Wallpaper>().clearWallpaper();
    Navigator.of(context).pop();
  }
}
