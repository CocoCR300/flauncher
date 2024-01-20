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
  final Duration    _updateInterval;
  final String      _dateTimeFormatString;
  final TextStyle?  _textStyle;

  const DateTimeWidget(String dateTimeFormatString, {
    Duration? updateInterval,
    TextStyle? textStyle
  }) :
      _dateTimeFormatString = dateTimeFormatString,
      _updateInterval = updateInterval ?? const Duration(seconds: 1),
      _textStyle = textStyle;

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState(
      _dateTimeFormatString, _updateInterval, _textStyle);
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  final Duration    _updateInterval;
  final DateFormat  _dateFormat;
  final TextStyle?  _textStyle;

  late DateTime _now;
  late Timer _timer;

  _DateTimeWidgetState(String dateTimeFormatString, Duration updateInterval, TextStyle? textStyle) :
      _updateInterval = updateInterval,
      _dateFormat = DateFormat(dateTimeFormatString, Platform.localeName),
      _textStyle = textStyle;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(_updateInterval, (_) => _refreshTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(_dateFormat.format(_now),
      style: _textStyle
  );

  void _refreshTime() {
    setState(() {
      _now = DateTime.now();
    });
  }
}
