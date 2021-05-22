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

class ScalingButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double scale;
  final bool autofocus;

  ScalingButton({
    required this.child,
    required this.onPressed,
    required this.scale,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        child: Builder(
          builder: (context) => AnimatedContainer(
            duration: Duration(milliseconds: 100),
            transformAlignment: Alignment.center,
            transform: Transform.scale(
              scale: Focus.of(context).hasFocus ? scale : 1.0,
            ).transform,
            child: child,
          ),
        ),
        onPressed: onPressed,
        autofocus: autofocus,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size.zero),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      );
}
