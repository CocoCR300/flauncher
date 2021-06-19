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
import 'package:flauncher/widgets/add_category_dialog.dart';
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesDialog extends StatefulWidget {
  @override
  CategoriesDialogState createState() => CategoriesDialogState();
}

class CategoriesDialogState extends State<CategoriesDialog> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          width: 500,
          height: 300,
          padding: EdgeInsets.all(24),
          color: Theme.of(context).backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Categories",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 16),
              Selector<AppsService, List<CategoryWithApps>>(
                selector: (_, appsService) => appsService.categoriesWithApps,
                builder: (context, categories, _) => Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children:
                          categories.asMap().keys.map((index) => _categoryTile(categories, index, context)).toList(),
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text("Add Category"),
                autofocus: true,
                onPressed: () async {
                  final categoryName = await showDialog<String>(context: context, builder: (_) => AddCategoryDialog());
                  if (categoryName != null) {
                    await context.read<AppsService>().addCategory(categoryName);
                  }
                },
              ),
            ],
          ),
        ),
      );

  Widget _categoryTile(List<CategoryWithApps> categories, int index, BuildContext context) => Padding(
        key: Key(categories[index].category.name),
        padding: EdgeInsets.only(bottom: 8),
        child: Card(
          margin: EdgeInsets.zero,
          child: EnsureVisible(
            alignment: 0.5,
            child: ListTile(
              title: Text(
                categories[index].category.name,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              dense: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints: BoxConstraints(),
                    splashRadius: 20,
                    icon: Icon(Icons.arrow_upward),
                    onPressed: index > 0 ? () => _move(index, index - 1) : null,
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    splashRadius: 20,
                    icon: Icon(Icons.arrow_downward),
                    onPressed: index < categories.length - 1 ? () => _move(index, index + 1) : null,
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    splashRadius: 20,
                    icon: Icon(Icons.delete),
                    onPressed: categories[index].category.name != "Applications"
                        ? () => _deleteCategory(context, categories[index].category)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _move(int oldIndex, int newIndex) async {
    await context.read<AppsService>().moveCategory(oldIndex, newIndex);
  }

  Future<void> _deleteCategory(BuildContext context, Category category) async {
    await context.read<AppsService>().deleteCategory(category);
  }
}
