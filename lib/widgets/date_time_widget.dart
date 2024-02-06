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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateTimeWidget extends StatefulWidget {
  final Duration?   updateInterval;
  final String      _dateTimeFormatString;
  final TextStyle?  textStyle;

  const DateTimeWidget(String dateTimeFormatString, {
    super.key,
    this.updateInterval,
    this.textStyle
  }) :
      _dateTimeFormatString = dateTimeFormatString;

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late DateFormat _dateFormat;
  late DateTime   _now;
  late Timer      _timer;

  @override
  void initState() {
    super.initState();

    _dateFormat = DateFormat(widget._dateTimeFormatString, Platform.localeName);
    _now = DateTime.now();
    _timer = Timer.periodic(widget.updateInterval ?? const Duration(seconds: 1), (_) => _refreshTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(_dateFormat.format(_now),
      style: widget.textStyle
  );

  void _refreshTime() {
    setState(() {
      _now = DateTime.now();
    });
  }
}
