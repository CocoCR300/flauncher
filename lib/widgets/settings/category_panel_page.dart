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
import 'package:flauncher/widgets/rename_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';

class CategoryPanelPage extends StatelessWidget {
  static const String routeName = "category_panel";

  final int categoryId;

  CategoryPanelPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
        child: Selector<AppsService, Category?>(
          selector: (_, appsService) => _categorySelector(appsService),
          builder: (_, category, __) => category != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(category.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                    Divider(),
                    _listTile(
                      context,
                      Text(localizations.name),
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
                      Text(localizations.sort),
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
                                child: Text(localizations.alphabetical, style: Theme.of(context).textTheme.bodySmall),
                              ),
                              DropdownMenuItem(
                                value: CategorySort.manual,
                                child: Text(localizations.manual, style: Theme.of(context).textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _listTile(
                      context,
                      Text(localizations.type),
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
                                child: Text(localizations.row, style: Theme.of(context).textTheme.bodySmall),
                              ),
                              DropdownMenuItem(
                                value: CategoryType.grid,
                                child: Text(localizations.grid, style: Theme.of(context).textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (category.type == CategoryType.grid)
                      _listTile(
                        context,
                        Text(localizations.columnCount),
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
                                      child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
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
                        Text(localizations.rowHeight),
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
                                      child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                        child: Text(localizations.delete),
                        onPressed: () async {
                          await context.read<AppsService>().deleteSection(category);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              : Container(),
        ),
      );
  }

  Category? _categorySelector(AppsService appsService) {
    Category? category;
    int index = appsService.categories.indexWhere((category) => category.id == categoryId);

    if (index == -1) {
      category = null;
    } else {
      category = appsService.categories[index];
    }

    return category;
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
