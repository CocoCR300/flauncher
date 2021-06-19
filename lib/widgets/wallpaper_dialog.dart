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

import 'package:flauncher/wallpaper_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallpaperDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SimpleDialog(
          title: Text("Wallpaper"),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  autofocus: true,
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
                  child: Text("SELECT"),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<WallpaperService>().clearWallpaper();
                    Navigator.of(context).pop();
                  },
                  child: Text("CLEAR"),
                ),
              ],
            ),
          ],
        ),
      );
}
