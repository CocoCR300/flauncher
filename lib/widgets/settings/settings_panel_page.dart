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
import 'package:flauncher/widgets/settings/status_bar_panel_page.dart';
import 'package:flauncher/widgets/settings/wallpaper_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../rounded_switch_list_tile.dart';
import 'back_button_actions.dart';

class SettingsPanelPage extends StatelessWidget {
  static const String routeName = "settings_panel";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<SettingsService>(
        builder: (context, settingsService, __) => SingleChildScrollView(
          child: Column(
            children: [
              Text(localizations.settings, style: Theme.of(context).textTheme.titleLarge),
              const Divider(),
              EnsureVisible(
                alignment: 0.5,
                child: TextButton(
                  child: Row(
                    children: [
                      const Icon(Icons.apps),
                      Container(width: 8),
                      Text(localizations.applications, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(ApplicationsPanelPage.routeName),
                ),
              ),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.category),
                    Container(width: 8),
                    Text(localizations.categories, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushNamed(CategoriesPanelPage.routeName),
              ),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.wallpaper_outlined),
                    Container(width: 8),
                    Text(localizations.wallpaper, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushNamed(WallpaperPanelPage.routeName),
              ),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates),
                    Container(width: 8),
                    Text(localizations.statusBar, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushNamed(StatusBarPanelPage.routeName),
              ),
              const Divider(),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined),
                    Container(width: 8),
                    Text(localizations.systemSettings, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () => context.read<AppsService>().openSettings(),
              ),
              const Divider(),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.date_range),
                    Container(width: 8),
                    Text(localizations.dateAndTimeFormat, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () async => await _dateTimeFormatDialog(context),
              ),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    Container(width: 8),
                    Text(localizations.backButtonAction, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                onPressed: () async => await _backButtonActionDialog(context),
              ),
              RoundedSwitchListTile(
                value: settingsService.appHighlightAnimationEnabled,
                onChanged: (value) => settingsService.setAppHighlightAnimationEnabled(value),
                title: Text(localizations.appCardHighlightAnimation, style: Theme.of(context).textTheme.bodyMedium),
                secondary: Icon(Icons.account_box_outlined),
              ),
              RoundedSwitchListTile(
                value: settingsService.appKeyClickEnabled,
                onChanged: (value) => settingsService.setAppKeyClickEnabled(value),
                title: Text(localizations.appKeyClick, style: Theme.of(context).textTheme.bodyMedium),
                secondary: Icon(Icons.add_alert_sharp),
              ),
              RoundedSwitchListTile(
                value: settingsService.showCategoryTitles,
                onChanged: (value) => settingsService.setShowCategoryTitles(value),
                title: Text(localizations.showCategoryTitles, style: Theme.of(context).textTheme.bodyMedium),
                secondary: Icon(Icons.abc)
              ),
              RoundedSwitchListTile(
                value: settingsService.autoHideAppBarEnabled,
                onChanged: (value) => settingsService.setAutoHideAppBarEnabled(value),
                title: Text(localizations.autoHideAppBar, style: Theme.of(context).textTheme.bodyMedium),
                secondary: Icon(Icons.visibility_off_outlined),
              ),
              const Divider(),
              TextButton(
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    Container(width: 8),
                    Text(localizations.aboutFlauncher, style: Theme.of(context).textTheme.bodyMedium),
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
  }

  Future<void> _backButtonActionDialog(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    SettingsService service = context.read<SettingsService>();

    final newAction = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
            title: Text(localizations.dialogTitleBackButtonAction),
            children: [
              SimpleDialogOption(
                child: Text(localizations.dialogOptionBackButtonActionDoNothing),
                onPressed: () => Navigator.pop(context, ""),
              ),
              SimpleDialogOption(
                child: Text(localizations.dialogOptionBackButtonActionShowClock),
                onPressed: () => Navigator.pop(context, BACK_BUTTON_ACTION_CLOCK),
              ),
              SimpleDialogOption(
                child: Text(localizations.dialogOptionBackButtonActionShowScreensaver),
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

    final formatTuple = await showDialog<Tuple2<String, String>>(
        context: context,
        builder: (_) => DateTimeFormatDialog(service.dateFormat, service.timeFormat)
    );

    if (formatTuple != null) {
      await service.setDateTimeFormat(formatTuple.item1, formatTuple.item2);
    }
  }
}
