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

import 'package:flauncher/apps_service.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/widgets/categories_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoveToCategoryDialog extends StatelessWidget {
  final Category excludedCategory;

  MoveToCategoryDialog({required this.excludedCategory});

  @override
  Widget build(BuildContext context) => Selector<AppsService, List<Category>>(
        selector: (_, appsService) => appsService.categoriesWithApps
            .map((categoryWithApps) => categoryWithApps.category)
            .where((category) => category.name != excludedCategory.name)
            .toList(),
        builder: (context, categories, _) => SimpleDialog(
          title: Text("Move to..."),
          contentPadding: EdgeInsets.all(16),
          children: [
            ...categories
                .map(
                  (category) => Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      onTap: () => Navigator.of(context).pop(category),
                      title: Text(category.name),
                    ),
                  ),
                )
                .toList(),
            TextButton.icon(
              autofocus: categories.isEmpty,
              onPressed: () => showDialog(context: context, builder: (_) => CategoriesDialog()),
              icon: Icon(Icons.category),
              label: Text("Manage categories"),
            ),
          ],
        ),
      );
}
