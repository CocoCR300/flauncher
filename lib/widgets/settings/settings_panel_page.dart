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
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flauncher/widgets/settings/applications_panel_page.dart';
import 'package:flauncher/widgets/settings/categories_panel_page.dart';
import 'package:flauncher/widgets/settings/date_time_format_dialog.dart';
import 'package:flauncher/widgets/settings/flauncher_about_dialog.dart';
import 'package:flauncher/widgets/settings/wallpaper_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'back_button_actions.dart';

class SettingsPanelPage extends StatelessWidget {
  static const String routeName = "settings_panel";

  @override
  Widget build(BuildContext context) => Consumer<SettingsService>(
        builder: (context, settingsService, __) => SingleChildScrollView(
          child: Column(
            children: [
              Text("Settings", style: Theme.of(context).textTheme.titleLarge),
              Divider(),
              EnsureVisible(
                alignment: 0.5,
                child: TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.apps),
                      Container(width: 8),
                      Text("Applications", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(ApplicationsPanelPage.routeName),
                ),
              ),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.category),
                    Container(width: 8),
                    Text("Categories", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushNamed(CategoriesPanelPage.routeName),
              ),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.wallpaper_outlined),
                    Container(width: 8),
                    Text("Wallpaper", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushNamed(WallpaperPanelPage.routeName),
              ),
              Divider(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    Container(width: 8),
                    Text("Android settings", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => context.read<AppsService>().openSettings(),
              ),
              Divider(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    Container(width: 8),
                    Text("Date and time format", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () async => await _dateTimeFormatDialog(context),
              ),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    Container(width: 8),
                    Text("Back button action", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () async => await _backButtonActionDialog(context),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                value: settingsService.appHighlightAnimationEnabled,
                onChanged: (value) => settingsService.setAppHighlightAnimationEnabled(value),
                title: Text("App card highlight animation"),
                dense: true,
              ),
              Divider(),
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    Container(width: 8),
                    Text("About FLauncher", style: Theme.of(context).textTheme.bodyMedium),
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
              ),
            ],
          ),
        ),
      );

  Future<void> _backButtonActionDialog(BuildContext context) async {
    SettingsService service = context.read<SettingsService>();

    final newAction = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text("Choose the back button action"),
            children: [
              SimpleDialogOption(
                child: const Text("Do nothing"),
                onPressed: () => Navigator.pop(context, ""),
              ),
              SimpleDialogOption(
                child: const Text("Hide UI"),
                onPressed: () => Navigator.pop(context, BACK_BUTTON_ACTION_HIDE_UI),
              ),
              SimpleDialogOption(
                child: const Text("Show screensaver"),
                onPressed: () => Navigator.pop(context, BACK_BUTTON_ACTION_SCREENSAVER),
              )
            ]
        )
    );

    if (newAction != null) {
      await service.setBackButtonAction(newAction);
    }
  }

  Future<void> _dateTimeFormatDialog(BuildContext context) async {
    SettingsService service = context.read<SettingsService>();

    final newFormat = await showDialog<String>(
        context: context,
        builder: (_) => DateTimeFormatDialog(initialValue: service.dateTimeFormat)
    );

    if (newFormat != null) {
      await service.setDateTimeFormat(newFormat);
    }
  }
}
