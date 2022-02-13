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

import 'dart:math';

import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flauncher/widgets/settings/categories_panel_page.dart';
import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppsGrid extends StatelessWidget {
  final Category category;
  final List<App> applications;

  AppsGrid({
    Key? key,
    required this.category,
    required this.applications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              category.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 8)]),
            ),
          ),
          applications.isNotEmpty
              ? GridView.custom(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: _buildSliverGridDelegate(),
                  padding: EdgeInsets.all(16),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => EnsureVisible(
                      key: Key("${category.id}-${applications[index].packageName}"),
                      alignment: 0.5,
                      child: AppCard(
                        category: category,
                        application: applications[index],
                        autofocus: index == 0,
                        onMove: (direction) => _onMove(context, direction, index),
                        onMoveEnd: () => _saveOrder(context),
                      ),
                    ),
                    childCount: applications.length,
                    findChildIndexCallback: _findChildIndex,
                  ),
                )
              : _emptyState(context),
        ],
      );

  int _findChildIndex(Key key) =>
      applications.indexWhere((app) => "${category.id}-${app.packageName}" == (key as ValueKey<String>).value);

  void _onMove(BuildContext context, AxisDirection direction, int index) {
    final currentRow = (index / category.columnsCount).floor();
    final totalRows = ((applications.length - 1) / category.columnsCount).floor();

    int? newIndex;
    switch (direction) {
      case AxisDirection.up:
        if (currentRow > 0) {
          newIndex = index - category.columnsCount;
        }
        break;
      case AxisDirection.right:
        if (index < applications.length - 1) {
          newIndex = index + 1;
        }
        break;
      case AxisDirection.down:
        if (currentRow < totalRows) {
          newIndex = min(index + category.columnsCount, applications.length - 1);
        }
        break;
      case AxisDirection.left:
        if (index > 0) {
          newIndex = index - 1;
        }
        break;
    }
    if (newIndex != null) {
      final appsService = context.read<AppsService>();
      appsService.reorderApplication(category, index, newIndex);
    }
  }

  void _saveOrder(BuildContext context) {
    final appsService = context.read<AppsService>();
    appsService.saveOrderInCategory(category);
  }

  SliverGridDelegate _buildSliverGridDelegate() => SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: category.columnsCount,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      );

  Widget _emptyState(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 110,
          child: EnsureVisible(
            alignment: 0.1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => SettingsPanel(initialRoute: CategoriesPanelPage.routeName),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            "This category is empty.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
