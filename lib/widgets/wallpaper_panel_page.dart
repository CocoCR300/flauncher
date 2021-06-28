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
import 'package:flauncher/widgets/unsplash_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class WallpaperPanelPage extends StatelessWidget {
  static const String routeName = "wallpaper_panel";

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text("Wallpaper", style: Theme.of(context).textTheme.headline6),
          Divider(),
          TextButton(
            autofocus: true,
            child: Row(
              children: [
                ImageIcon(AssetImage("assets/unsplash.png")),
                Container(width: 8),
                Text("Unsplash", style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            onPressed: () => Navigator.of(context).pushNamed(UnsplashPanelPage.routeName),
          ),
          TextButton(
            child: Row(
              children: [
                Icon(Icons.wallpaper),
                Container(width: 8),
                Text("Custom", style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            onPressed: () async {
              try {
                await context.read<WallpaperService>().pickWallpaper();
                Navigator.of(context).pop();
              } on NoFileExplorerException {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 8),
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Please install a file explorer in order pick an image.")
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          TextButton(
            child: Row(
              children: [
                Icon(Icons.clear),
                Container(width: 8),
                Text("Clear", style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            onPressed: () => context.read<WallpaperService>().clearWallpaper(),
          ),
        ],
      );
}
