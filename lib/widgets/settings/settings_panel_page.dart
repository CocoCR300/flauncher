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
import 'package:flauncher/widgets/settings/applications_panel_page.dart';
import 'package:flauncher/widgets/settings/categories_panel_page.dart';
import 'package:flauncher/widgets/settings/flauncher_about_dialog.dart';
import 'package:flauncher/widgets/settings/wallpaper_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsPanelPage extends StatelessWidget {
  static const String routeName = "settings_panel";

  @override
  Widget build(BuildContext context) => Consumer<SettingsService>(
        builder: (context, settingsService, __) => Column(
          children: [
            Text("Settings", style: Theme.of(context).textTheme.headline6),
            Divider(),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.apps),
                  Container(width: 8),
                  Text("Applications", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () => Navigator.of(context).pushNamed(ApplicationsPanelPage.routeName),
            ),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.category),
                  Container(width: 8),
                  Text("Categories", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () => Navigator.of(context).pushNamed(CategoriesPanelPage.routeName),
            ),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.wallpaper_outlined),
                  Container(width: 8),
                  Text("Wallpaper", style: Theme.of(context).textTheme.bodyText2),
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
                  Text("Android settings", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () => context.read<AppsService>().openSettings(),
            ),
            Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              value: settingsService.use24HourTimeFormat,
              onChanged: (value) => settingsService.setUse24HourTimeFormat(value),
              title: Text("Use 24-hour time format"),
              dense: true,
            ),
            Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              value: settingsService.crashReportsEnabled,
              onChanged: (value) => settingsService.setCrashReportsEnabled(value),
              title: Text("Crash Reporting"),
              dense: true,
              subtitle: Text("Automatically send crash reports through Firebase Crashlytics."),
            ),
            Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              value: settingsService.analyticsEnabled,
              onChanged: (value) => settingsService.setAnalyticsEnabled(value),
              title: Text("Analytics Reporting"),
              dense: true,
              subtitle: Text("Share analytics data through Firebase Analytics."),
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
            ),
          ],
        ),
      );
}
