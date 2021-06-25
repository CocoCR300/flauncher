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

import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/widgets/categories_dialog.dart';
import 'package:flauncher/widgets/flauncher_about_dialog.dart';
import 'package:flauncher/widgets/right_panel_dialog.dart';
import 'package:flauncher/widgets/wallpaper_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RightPanelDialog(
        width: 300,
        child: Consumer<SettingsService>(
          builder: (_, settings, __) => Column(
            children: [
              Text("Settings", style: Theme.of(context).textTheme.headline6),
              Divider(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.category),
                    Container(width: 8),
                    Text("Categories", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                onPressed: () => showDialog(context: context, builder: (context) => CategoriesDialog()),
              ),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.wallpaper_outlined),
                    Container(width: 8),
                    Text("Wallpaper", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                onPressed: () => showDialog(context: context, builder: (context) => WallpaperDialog()),
              ),
              Divider(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    Container(width: 8),
                    Text("Android settings", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                onPressed: () => context.read<AppsService>().openSettings(),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Focus effect"),
                          Text(
                            "'Zoom' may cause navigation issues on non-TV Android versions.",
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<FocusEffect>(
                      value: settings.focusEffect,
                      onChanged: (value) => settings.setFocusEffect(value!),
                      items: [
                        DropdownMenuItem(value: FocusEffect.zoom, child: Text("Zoom")),
                        DropdownMenuItem(value: FocusEffect.glow, child: Text("Glow")),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                value: settings.crashReportsEnabled,
                onChanged: (value) => settings.setCrashReportsEnabled(value),
                title: Text("Crash Reporting"),
                dense: true,
                subtitle: Text("Automatically send crash reports through Firebase Crashlytics."),
              ),
              Spacer(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    Container(width: 8),
                    Text("About FLauncher", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
                        ? FLauncherAboutDialog(packageInfo: snapshot.data!)
                        : Container(),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
