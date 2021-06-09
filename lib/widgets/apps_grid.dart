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

import 'package:flauncher/application_info.dart';
import 'package:flauncher/apps.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _crossAxisCount = 6;

class AppsGrid extends StatelessWidget {
  final List<ApplicationInfo> apps;
  final VoidCallback onFirstRowFocused;

  final VoidCallback onLastRowFocused;

  AppsGrid({
    required this.apps,
    required this.onFirstRowFocused,
    required this.onLastRowFocused,
  });

  @override
  Widget build(BuildContext context) => GridView.custom(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          childAspectRatio: 16 / 9,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        childrenDelegate: SliverChildBuilderDelegate(
          (_, index) => Focus(
            key: Key(apps[index].packageName),
            canRequestFocus: false,
            onFocusChange: (focused) {
              if (focused) {
                _adjustScroll(index, apps.length);
              }
            },
            child: AppCard(
              application: apps[index],
              autofocus: index == 0,
              onMove: (direction) => _onMove(context, direction, index),
            ),
          ),
          findChildIndexCallback: (key) => apps
              .indexWhere((app) => app.packageName == (key as ValueKey).value),
          childCount: apps.length,
        ),
      );

  void _adjustScroll(int index, int appsCount) {
    final currentRow = (index / _crossAxisCount).floor();
    final totalRows = (appsCount / _crossAxisCount).floor();

    if (currentRow == 0) {
      onFirstRowFocused();
    } else if (currentRow == totalRows) {
      onLastRowFocused();
    }
  }

  Future<void> _onMove(
      BuildContext context, AxisDirection direction, int index) async {
    final currentRow = (index / _crossAxisCount).floor();
    final totalRows = ((apps.length - 1) / _crossAxisCount).floor();

    int? newIndex;
    switch (direction) {
      case AxisDirection.up:
        if (currentRow > 0) {
          newIndex = index - _crossAxisCount;
        }
        break;
      case AxisDirection.right:
        if (index < apps.length - 1) {
          newIndex = index + 1;
        }
        break;
      case AxisDirection.down:
        if (currentRow < totalRows) {
          newIndex = min(index + _crossAxisCount, apps.length - 1);
        }
        break;
      case AxisDirection.left:
        if (index > 0) {
          newIndex = index - 1;
        }
        break;
    }
    if (newIndex != null) {
      await _moveTo(context, newIndex, apps[index]);
      _adjustScroll(newIndex, apps.length);
    }
  }

  Future<void> _moveTo(BuildContext context, int targetIndex,
      ApplicationInfo applicationInfo) async {
    final apps = context.read<Apps>();
    await apps.moveApplicationTo(targetIndex, applicationInfo);
  }
}
