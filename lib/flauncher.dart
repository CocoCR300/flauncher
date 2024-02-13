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

import 'dart:ui';

import 'package:flauncher/custom_traversal_policy.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/apps_grid.dart';
import 'package:flauncher/widgets/category_row.dart';
import 'package:flauncher/widgets/launcher_alternative_view.dart';
import 'package:flauncher/widgets/network_widget.dart';
import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flauncher/widgets/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
              appBar: _appBar(context),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Consumer<AppsService>(
                  builder: (context, appsService, _) {
                    if (appsService.initialized) {
                      return SingleChildScrollView(child: _categories(appsService.categoriesWithApps));
                    }
                    else {
                      return _emptyState(context);
                    }
                  }
                ),
              ),
            )
        ),
      ],
    ),
  );

  Widget _categories(List<CategoryWithApps> categoriesWithApps) => Column(
    children: categoriesWithApps.map((categoryWithApps) {
      switch (categoryWithApps.category.type) {
        case CategoryType.row:
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CategoryRow(
                key: Key(categoryWithApps.category.id.toString()),
                category: categoryWithApps.category,
                applications: categoryWithApps.applications),
          );
        case CategoryType.grid:
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AppsGrid(
                key: Key(categoryWithApps.category.id.toString()),
                category: categoryWithApps.category,
                applications: categoryWithApps.applications),
          );
      }
    }).toList(),
  );

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(),
          splashRadius: 20,
          icon: const Icon(Icons.settings_outlined,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          onPressed: () => showDialog(context: context, builder: (_) => const SettingsPanel()),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: NetworkWidget(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 32),
          child: Selector<SettingsService, Tuple2<String, String>>(
            // TODO: This selector is not working
            selector:  (context, service) => Tuple2(service.dateFormat, service.timeFormat),
            builder: (context, formatTuple, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: DateTimeWidget(formatTuple.item1,
                      updateInterval: const Duration(minutes: 1),
                      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        shadows: [
                          const Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 8)
                        ],
                      ),
                    )
                  ),
                  if (formatTuple.item1.isNotEmpty && formatTuple.item2.isNotEmpty)
                    const SizedBox(width: 16),
                  Flexible(
                    child: DateTimeWidget(formatTuple.item2,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          shadows: [
                            const Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 8)
                          ],
                        )
                    )
                  )
                ]
            );
            },
          ),
        ),
      ],
    );
  }

  Widget _wallpaper(BuildContext context, WallpaperService wallpaperService) {
    if (wallpaperService.wallpaper != null) {
      final physicalSize = MediaQuery.sizeOf(context);
      return Image(
          image: wallpaperService.wallpaper!,
          key: const Key("background"),
          fit: BoxFit.cover,
          height: physicalSize.height,
          width: physicalSize.width);
    }
    else {
      return Container(key: const Key("background"), decoration: BoxDecoration(gradient: wallpaperService.gradient.gradient));
    }
  }

  Widget _emptyState(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text("Loading", style: Theme.of(context).textTheme.titleLarge),
      ],
    ),
  );
}
