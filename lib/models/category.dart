/*
 * FLauncher
 * Copyright (C) 2024 Oscar Rojas
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

import 'dart:collection';

import '../database.dart';
import 'app.dart';

class Category
{
  static const int          ColumnsCount  = 6;
  static const int          RowHeight     = 110;
  static const CategorySort Sort          = CategorySort.manual;
  static const CategoryType Type          = CategoryType.row;

  final int id;

  final int columnsCount;

  int order;

  final int rowHeight;

  final String name;

  final CategorySort  sort;

  final CategoryType  type;

  final List<App>     applications;

  Category({
    required this.name,
    this.order = 0,
    this.id = 0,
    this.columnsCount = Category.ColumnsCount,
    this.rowHeight = Category.RowHeight,
    this.sort = Category.Sort,
    this.type = Category.Type}):
        applications = [];

  Category.withApplications({
    required this.name,
    required this.applications,
    this.order = 0,
    this.id = 0,
    this.columnsCount = Category.ColumnsCount,
    this.rowHeight = Category.RowHeight,
    this.sort = Category.Sort,
    this.type = Category.Type});

  Category unmodifiable() {
    return Category.withApplications(
      name: name,
      order: order,
      id: id,
      columnsCount: columnsCount,
      rowHeight: rowHeight,
      sort: sort,
      type: type,
      applications: UnmodifiableListView(applications));
  }
}