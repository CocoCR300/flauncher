/*
 * FLauncher
 * Copyright (C) 2021  Oscar Rojas
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/settings_service.dart';

class StatusBarPanelPage extends StatelessWidget {
  static const String routeName = "status_bar_panel";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    SettingsService settingsService = Provider.of(context);

    return Column(
        children: [
          Text(localizations.statusBar, style: Theme.of(context).textTheme.titleLarge),
          Divider(),
          Text(localizations.titleStatusBarSettingsPage,
            textAlign: TextAlign.start), // TODO: Setting the alignment doesn't work
          SizedBox(height: 8, width: 0),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            value: settingsService.showDateInStatusBar,
            onChanged: (value) => settingsService.setShowDateInStatusBar(value),
            title: Text(localizations.date),
            dense: true,
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            value: settingsService.showTimeInStatusBar,
            onChanged: (value) => settingsService.setShowTimeInStatusBar(value),
            title: Text(localizations.time),
            dense: true,
          ),
        ],
      );
  }
}
