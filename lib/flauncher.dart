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
import 'package:flauncher/wallpaper_dialog.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flauncher/widgets/date_time_widget.dart';
import 'package:flauncher/widgets/scaling_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class FLauncher extends StatefulWidget {
  @override
  _FLauncherState createState() => _FLauncherState();
}

class _FLauncherState extends State<FLauncher> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Consumer<Wallpaper>(
            builder: (_, wallpaper, __) => _wallpaper(wallpaper.wallpaperBytes),
          ),
          Scaffold(
            appBar: _appBar(context),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListView(
                    children: [
                      Focus(child: Container(height: 80)),
                      Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          "Applications",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Consumer<Apps>(
                        builder: (context, apps, _) => apps
                                .installedApplications.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: _gridDelegate(),
                                itemCount: apps.installedApplications.length,
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                itemBuilder: (_, int index) => AppCard(
                                  application:
                                      apps.installedApplications[index],
                                  autofocus: index == 0,
                                ),
                              ),
                      ),
                      Focus(child: Container(height: 80))
                    ],
                  ),
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.done
                          ? Text(
                              "v${snapshot.data!.version}",
                              style: Theme.of(context).textTheme.overline,
                            )
                          : Container(),
                )
              ],
            ),
          ),
        ],
      );

  AppBar _appBar(BuildContext context) => AppBar(
        actions: [
          ScalingButton(
            scale: 1.2,
            child: Icon(Icons.wallpaper),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => WallpaperDialog(),
            ),
          ),
          Container(width: 8),
          ScalingButton(
            scale: 1.2,
            child: Icon(Icons.settings_outlined),
            onPressed: () => context.read<Apps>().openSettings(),
          ),
          VerticalDivider(
            width: 24,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DateTimeWidget(),
          ),
        ],
      );

  Widget _wallpaper(Uint8List? wallpaperImage) => wallpaperImage != null
      ? Image.memory(
          wallpaperImage,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        )
      : Container(color: Colors.white12);

  SliverGridDelegate _gridDelegate() =>
      SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 16 / 9,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16);
}
