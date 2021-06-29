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

import 'package:flauncher/widgets/gradient_panel_page.dart';
import 'package:flauncher/widgets/right_panel_dialog.dart';
import 'package:flauncher/widgets/settings_panel_page.dart';
import 'package:flauncher/widgets/unsplash_panel_page.dart';
import 'package:flauncher/widgets/wallpaper_panel_page.dart';
import 'package:flutter/material.dart';

class SettingsPanel extends StatefulWidget {
  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
        child: RightPanelDialog(
          width: 300,
          child: Navigator(
            key: _navigatorKey,
            initialRoute: SettingsPanelPage.routeName,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case SettingsPanelPage.routeName:
                  return MaterialPageRoute(builder: (_) => SettingsPanelPage());
                case WallpaperPanelPage.routeName:
                  return MaterialPageRoute(builder: (_) => WallpaperPanelPage());
                case UnsplashPanelPage.routeName:
                  return MaterialPageRoute(builder: (_) => UnsplashPanelPage());
                case GradientPanelPage.routeName:
                  return MaterialPageRoute(builder: (_) => GradientPanelPage());
              }
            },
          ),
        ),
      );
}
