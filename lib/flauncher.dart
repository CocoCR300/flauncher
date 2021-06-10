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

import 'package:flauncher/apps.dart';
import 'package:flauncher/wallpaper.dart';
import 'package:flauncher/widgets/apps_grid.dart';
import 'package:flauncher/widgets/favorites_row.dart';
import 'package:flauncher/widgets/settings_panel.dart';
import 'package:flauncher/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class FLauncher extends StatefulWidget {
  @override
  _FLauncherState createState() => _FLauncherState();
}

class _FLauncherState extends State<FLauncher> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Consumer<Wallpaper>(
            builder: (_, wallpaper, __) =>
                _wallpaper(context, wallpaper.wallpaperBytes),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(context),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Consumer<Apps>(
                    builder: (context, apps, _) => ListView(
                      controller: _scrollController,
                      children: [
                        if (apps.favorites.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 8),
                            child: Text(
                              "Favorites",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        if (apps.favorites.isNotEmpty)
                          FavoritesRow(favorites: apps.favorites)
                        else
                          Container(height: 80),
                        Padding(
                          padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
                          child: Text(
                            "Applications",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        AppsGrid(
                          apps: apps.applications,
                          onFirstRowFocused: () => _scroll(0.0),
                          onLastRowFocused: () => _scroll(
                              _scrollController.position.maxScrollExtent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  AppBar _appBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            splashRadius: 20,
            icon: Icon(Icons.settings_outlined),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => SettingsPanel(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 32),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 64,
                height: 24,
                child: TimeWidget(),
              ),
            ),
          ),
        ],
      );

  Widget _wallpaper(BuildContext context, Uint8List? wallpaperImage) =>
      wallpaperImage != null
          ? Image.memory(
              wallpaperImage,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            )
          : Container(color: Theme.of(context).scaffoldBackgroundColor);

  void _scroll(double position) => _scrollController.animateTo(position,
      duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
}
