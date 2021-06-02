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

class TVInkWellCard extends StatefulWidget {
  final Widget child;
  final bool autofocus;
  final GestureTapCallback? onPressed;
  final GestureTapCallback? onLongPress;

  TVInkWellCard({
    required this.child,
    this.autofocus = false,
    this.onPressed,
    this.onLongPress,
  });

  @override
  _TVInkWellCardState createState() => _TVInkWellCardState();
}

class _TVInkWellCardState extends State<TVInkWellCard> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          focusColor: Colors.transparent,
          onHighlightChanged: (highlighted) {
            if (highlighted) {
              _focusNode.requestFocus();
            }
          },
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          child: widget.child,
        ),
      );
}
