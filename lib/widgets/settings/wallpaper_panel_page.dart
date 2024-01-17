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
import 'package:flauncher/widgets/settings/gradient_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallpaperPanelPage extends StatelessWidget {
  static const String routeName = "wallpaper_panel";

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text("Wallpaper", style: Theme.of(context).textTheme.titleLarge),
          Divider(),
          TextButton(
            autofocus: true,
            child: Row(
              children: [
                Icon(Icons.gradient),
                Container(width: 8),
                Text("Gradient", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            onPressed: () => Navigator.of(context).pushNamed(GradientPanelPage.routeName),
          ),
          TextButton(
            child: Row(
              children: [
                Icon(Icons.insert_drive_file_outlined),
                Container(width: 8),
                Text("Custom", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            onPressed: () async {
              try {
                await context.read<WallpaperService>().pickWallpaper();
              } on NoFileExplorerException {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 8),
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Please install a file explorer in order to pick an image.")
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      );
}
