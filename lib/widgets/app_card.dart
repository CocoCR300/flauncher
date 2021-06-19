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

import 'dart:typed_data';
import 'dart:ui';

import 'package:flauncher/apps_service.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/long_press_detector.dart';
import 'package:flauncher/widgets/tv_ink_well_card.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const _validationKeys = [LogicalKeyboardKey.select, LogicalKeyboardKey.enter];

class AppCard extends StatefulWidget {
  final Category category;
  final App application;
  final bool autofocus;
  final void Function(AxisDirection) onMove;
  final VoidCallback onMoveEnd;

  AppCard({
    Key? key,
    required this.category,
    required this.application,
    required this.autofocus,
    required this.onMove,
    required this.onMoveEnd,
  }) : super(key: key);

  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _moving = false;
  MemoryImage? _imageProvider;

  ImageProvider _cachedMemoryImage(Uint8List bytes) {
    if (!listEquals(bytes, _imageProvider?.bytes)) {
      _imageProvider = MemoryImage(bytes);
    }
    return _imageProvider!;
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 16 / 9,
        child: LongPressDetector(
          onPressed: (key) => _onPressed(context, key),
          onLongPress: (key) => _onLongPress(context, key),
          child: Builder(
            builder: (context) => AnimatedContainer(
              duration: Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              transformAlignment: Alignment.center,
              transform: Transform.scale(
                scale: _moving
                    ? 1.0
                    : Focus.of(context).hasFocus
                        ? 1.15
                        : 1.0,
              ).transform,
              child: Stack(
                children: [
                  TVInkWellCard(
                    autofocus: widget.autofocus,
                    onPressed: () => _onPressed(context, null),
                    onLongPress: () => _onLongPress(context, null),
                    child: widget.application.banner != null
                        ? Ink.image(image: _cachedMemoryImage(widget.application.banner!))
                        : Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Ink.image(image: _cachedMemoryImage(widget.application.icon!)),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.application.name,
                                    style: Theme.of(context).textTheme.caption,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                  if (_moving) ..._arrows(),
                  IgnorePointer(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      opacity: Focus.of(context).hasFocus ? 0 : 0.25,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  List<Widget> _arrows() => [
        _arrow(Alignment.centerLeft, Icons.keyboard_arrow_left),
        _arrow(Alignment.topCenter, Icons.keyboard_arrow_up),
        _arrow(Alignment.bottomCenter, Icons.keyboard_arrow_down),
        _arrow(Alignment.centerRight, Icons.keyboard_arrow_right),
      ];

  Widget _arrow(Alignment alignment, IconData icon) => Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
            child: Icon(
              icon,
              size: 16,
            ),
          ),
        ),
      );

  KeyEventResult _onPressed(BuildContext context, LogicalKeyboardKey? key) {
    if (_moving) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => Scrollable.ensureVisible(context,
          alignment: 0.1, duration: Duration(milliseconds: 100), curve: Curves.easeInOut));
      if (key == LogicalKeyboardKey.arrowLeft) {
        widget.onMove(AxisDirection.left);
      } else if (key == LogicalKeyboardKey.arrowUp) {
        widget.onMove(AxisDirection.up);
      } else if (key == LogicalKeyboardKey.arrowRight) {
        widget.onMove(AxisDirection.right);
      } else if (key == LogicalKeyboardKey.arrowDown) {
        widget.onMove(AxisDirection.down);
      } else if (_validationKeys.contains(key)) {
        setState(() => _moving = false);
        widget.onMoveEnd();
      }
      return KeyEventResult.handled;
    } else if (_validationKeys.contains(key)) {
      context.read<AppsService>().launchApp(widget.application);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _onLongPress(BuildContext context, LogicalKeyboardKey? key) {
    if (!_moving && (key == null || longPressableKeys.contains(key))) {
      _showPanel(context);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _showPanel(BuildContext context) async {
    final result = await showDialog<ApplicationInfoPanelResult>(
      context: context,
      builder: (context) => ApplicationInfoPanel(
        category: widget.category,
        application: widget.application,
      ),
    );
    if (result == ApplicationInfoPanelResult.reorderApp) {
      setState(() => _moving = true);
    }
  }
}
