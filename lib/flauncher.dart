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


import 'package:flauncher/custom_traversal_policy.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/apps_grid.dart';
import 'package:flauncher/widgets/category_row.dart';
import 'package:flauncher/widgets/launcher_alternative_view.dart';
import 'package:flauncher/widgets/settings/focus_aware_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/category.dart';

class FLauncher extends StatelessWidget {
  const FLauncher();

  @override
  Widget build(BuildContext context) => FocusTraversalGroup(
    policy: RowByRowTraversalPolicy(),
    child: Stack(
      children: [
        Consumer<WallpaperService>(
          builder: (_, wallpaperService, __) => _wallpaper(context, wallpaperService)
        ),
        Consumer<LauncherState>(
          builder: (_, state, child) => Visibility(
            child: child!,
            replacement: const Center(
              child: AlternativeLauncherView()
            ),
            visible: state.launcherVisible
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: FocusAwareAppBar(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Consumer<AppsService>(
                builder: (context, appsService, _) {
                  if (appsService.initialized) {
                    return SingleChildScrollView(child: _categories(appsService.categories));
                  }
                  else {
                    return _emptyState(context);
                  }
                }
              )
            )
          )
        )
      ]
    )
  );

  Widget _categories(List<Category> categories) => Column(
    children: categories.map((category) {
      final Key categoryKey = Key(category.id.toString());
      final Widget categoryWidget;

      switch (category.type) {
        case CategoryType.row:
          categoryWidget =  CategoryRow(
            key: categoryKey,
            category: category,
            applications: category.applications
          );
        case CategoryType.grid:
          categoryWidget = AppsGrid(
            key: categoryKey,
            category: category,
            applications: category.applications
          );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: categoryWidget
      );
    }).toList(),
  );

  Widget _wallpaper(BuildContext context, WallpaperService wallpaperService) {
    if (wallpaperService.wallpaper != null) {
      final physicalSize = MediaQuery.sizeOf(context);
      return Image(
        image: wallpaperService.wallpaper!,
        key: const Key("background"),
        fit: BoxFit.cover,
        height: physicalSize.height,
        width: physicalSize.width
      );
    }
    else {
      return Container(key: const Key("background"), decoration: BoxDecoration(gradient: wallpaperService.gradient.gradient));
    }
  }

  Widget _emptyState(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(localizations.loading, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
