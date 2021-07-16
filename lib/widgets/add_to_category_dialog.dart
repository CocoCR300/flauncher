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

import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCategoryDialog extends StatelessWidget {
  final App application;

  AddToCategoryDialog(this.application);

  @override
  Widget build(BuildContext context) => Selector<AppsService, List<Category>>(
        selector: (_, appsService) => appsService.categoriesWithApps
            .where((element) => !element.applications.any((app) => app.packageName == application.packageName))
            .map((categoryWithApps) => categoryWithApps.category)
            .toList(),
        builder: (context, categories, _) => SimpleDialog(
          title: Text("Add to..."),
          contentPadding: EdgeInsets.all(16),
          children: categories
              .map(
                (category) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    onTap: () async {
                      await context.read<AppsService>().addToCategory(application, category);
                      Navigator.of(context).pop();
                    },
                    title: Text(category.name),
                  ),
                ),
              )
              .toList(),
        ),
      );
}
