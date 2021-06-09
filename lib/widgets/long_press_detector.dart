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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const longPressableKeys = [LogicalKeyboardKey.select, LogicalKeyboardKey.enter];

class LongPressDetector extends StatefulWidget {
  final Widget child;
  final KeyEventResult Function(LogicalKeyboardKey)? onPressed;
  final KeyEventResult Function(LogicalKeyboardKey)? onLongPress;

  LongPressDetector({
    required this.child,
    this.onPressed,
    this.onLongPress,
  });

  @override
  _LongPressDetectorState createState() => _LongPressDetectorState();
}

class _LongPressDetectorState extends State<LongPressDetector> {
  int? _keyDownAt;

  @override
  Widget build(BuildContext context) => Focus(
        canRequestFocus: false,
        onKey: (_, rawKeyEvent) => _handleKey(context, rawKeyEvent),
        child: widget.child,
      );

  KeyEventResult _handleKey(BuildContext context, RawKeyEvent rawKeyEvent) {
    switch (rawKeyEvent.runtimeType) {
      case RawKeyDownEvent:
        return _keyDownEvent(context, rawKeyEvent.logicalKey,
            (rawKeyEvent.data as RawKeyEventDataAndroid));
      case RawKeyUpEvent:
        return _keyUpEvent(context, rawKeyEvent.logicalKey);
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _keyDownEvent(BuildContext context, LogicalKeyboardKey key,
      RawKeyEventDataAndroid data) {
    if (!longPressableKeys.contains(key)) {
      return widget.onPressed?.call(key) ?? KeyEventResult.ignored;
    }
    if (data.repeatCount == 0) {
      _keyDownAt = DateTime.now().millisecondsSinceEpoch;
      return KeyEventResult.ignored;
    } else if (_longPress()) {
      _keyDownAt = null;
      return widget.onLongPress?.call(key) ?? KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _keyUpEvent(BuildContext context, LogicalKeyboardKey key) {
    if (_keyDownAt != null) {
      _keyDownAt = null;
      return widget.onPressed?.call(key) ?? KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  bool _longPress() =>
      _keyDownAt != null &&
      DateTime.now().millisecondsSinceEpoch - _keyDownAt! >= 500;
}
