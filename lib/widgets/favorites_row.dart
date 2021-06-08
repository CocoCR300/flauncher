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
import 'package:flauncher/widgets/app_card.dart';
import 'package:flutter/material.dart';

class FavoritesRow extends StatelessWidget {
  final List<ApplicationInfo> favorites;

  FavoritesRow({
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 120,
        child: ListView.builder(
          itemCount: favorites.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: AppCard(
                application: favorites[index],
                autofocus: index == 0,
              ),
            ),
          ),
        ),
      );
}
