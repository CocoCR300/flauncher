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

import 'dart:async';

import 'package:flauncher/providers/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimeWidget extends StatefulWidget {
  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _refreshTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Selector<SettingsService, bool>(
        selector: (_, settingsService) => settingsService.use24HourTimeFormat,
        builder: (context, use24HourTimeFormat, _) => Text(
          use24HourTimeFormat ? DateFormat.Hm().format(_now) : DateFormat.jm().format(_now),
          style: Theme.of(context).textTheme.headline6!.copyWith(
            shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 8)],
          ),
          textAlign: TextAlign.end,
        ),
      );

  void _refreshTime() {
    setState(() {
      _now = DateTime.now();
    });
  }
}
