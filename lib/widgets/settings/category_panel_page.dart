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
import 'package:flauncher/widgets/add_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPanelPage extends StatelessWidget {
  static const String routeName = "category_panel";

  final int categoryId;

  CategoryPanelPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Selector<AppsService, Category?>(
          selector: (_, appsService) => _categorySelector(appsService),
          builder: (_, category, __) => category != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(category.name, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                    Divider(),
                    _listTile(
                      context,
                      Text("Name"),
                      Text(category.name),
                      trailing: IconButton(
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                        icon: Icon(Icons.edit),
                        onPressed: () => _renameCategory(context, category),
                      ),
                    ),
                    _listTile(
                      context,
                      Text("Sort"),
                      Column(
                        children: [
                          SizedBox(height: 4),
                          DropdownButton<CategorySort>(
                            value: category.sort,
                            onChanged: (value) => context.read<AppsService>().setCategorySort(category, value!),
                            isDense: true,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: CategorySort.alphabetical,
                                child: Text("Alphabetical", style: Theme.of(context).textTheme.caption),
                              ),
                              DropdownMenuItem(
                                value: CategorySort.manual,
                                child: Text("Manual", style: Theme.of(context).textTheme.caption),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _listTile(
                      context,
                      Text("Type"),
                      Column(
                        children: [
                          SizedBox(height: 4),
                          DropdownButton<CategoryType>(
                            value: category.type,
                            onChanged: (value) => context.read<AppsService>().setCategoryType(category, value!),
                            isDense: true,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: CategoryType.row,
                                child: Text("Row", style: Theme.of(context).textTheme.caption),
                              ),
                              DropdownMenuItem(
                                value: CategoryType.grid,
                                child: Text("Grid", style: Theme.of(context).textTheme.caption),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (category.type == CategoryType.grid)
                      _listTile(
                        context,
                        Text("Columns count"),
                        Column(
                          children: [
                            SizedBox(height: 4),
                            DropdownButton<int>(
                              value: category.columnsCount,
                              isDense: true,
                              isExpanded: true,
                              items: [for (int i = 5; i <= 10; i++) i]
                                  .map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.toString(), style: Theme.of(context).textTheme.caption),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  context.read<AppsService>().setCategoryColumnsCount(category, value!),
                            ),
                          ],
                        ),
                      ),
                    if (category.type == CategoryType.row)
                      _listTile(
                        context,
                        Text("Row height"),
                        Column(
                          children: [
                            SizedBox(height: 4),
                            DropdownButton<int>(
                              value: category.rowHeight,
                              isDense: true,
                              isExpanded: true,
                              items: [for (int i = 80; i <= 150; i += 10) i]
                                  .map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.toString(), style: Theme.of(context).textTheme.caption),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => context.read<AppsService>().setCategoryRowHeight(category, value!),
                            ),
                          ],
                        ),
                      ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                        child: Text("Delete"),
                        onPressed: () async {
                          await context.read<AppsService>().deleteCategory(category);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              : Container(),
        ),
      );

  Category? _categorySelector(AppsService appsService) {
    final index = appsService.categoriesWithApps.indexWhere((element) => element.category.id == categoryId);
    return index == -1 ? null : appsService.categoriesWithApps[index].category;
  }

  Widget _listTile(BuildContext context, Widget title, Widget subtitle, {Widget? trailing}) => Material(
        type: MaterialType.transparency,
        child: ListTile(
          dense: true,
          minVerticalPadding: 8,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      );

  Future<void> _renameCategory(BuildContext context, Category category) async {
    final categoryName =
        await showDialog<String>(context: context, builder: (_) => AddCategoryDialog(initialValue: category.name));
    if (categoryName != null) {
      await context.read<AppsService>().renameCategory(category, categoryName);
    }
  }
}
