/*
 * FLauncher
 * Copyright (C) 2021  Oscar Rojas
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

import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/widgets/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlternativeLauncherView extends StatelessWidget {
  const AlternativeLauncherView();

  @override
  Widget build(BuildContext context) => Consumer<SettingsService>(
    builder: (context, service, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DateTimeWidget(service.timeFormat,
              textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 8)],
              )
          ),
          DateTimeWidget(service.dateFormat,
              updateInterval: Duration(minutes: 1),
              textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 8)],
              )
          )
        ],
      ),
  );
}
