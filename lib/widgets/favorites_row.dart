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

import 'package:flauncher/application_info.dart';
import 'package:flauncher/apps.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesRow extends StatelessWidget {
  final List<ApplicationInfo> favorites;

  FavoritesRow({
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 120,
        child: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              key: Key(favorites[index].packageName),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: AppCard(
                  application: favorites[index],
                  autofocus: index == 0,
                  onMove: (direction) => _onMove(context, direction, index),
                ),
              ),
            ),
            findChildIndexCallback: (key) => favorites.indexWhere(
                (app) => app.packageName == (key as ValueKey).value),
            childCount: favorites.length,
          ),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
        ),
      );

  Future<void> _onMove(
      BuildContext context, AxisDirection direction, int index) async {
    switch (direction) {
      case AxisDirection.right:
        if (index < favorites.length - 1) {
          await _moveTo(context, index + 1, favorites[index]);
        }
        break;
      case AxisDirection.left:
        if (index > 0) {
          await _moveTo(context, index - 1, favorites[index]);
        }
        break;
      default:
        break;
    }
  }

  Future<void> _moveTo(BuildContext context, int targetIndex,
      ApplicationInfo applicationInfo) async {
    final apps = context.read<Apps>();
    await apps.moveFavoriteTo(targetIndex, applicationInfo);
  }
}
