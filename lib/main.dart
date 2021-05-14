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

import 'package:flauncher/FLauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        shortcuts: WidgetsApp.defaultShortcuts
          ..addAll(
              {LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent()}),
        title: 'FLauncher',
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: Colors.white),
          typography: Typography.material2018(),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: FLauncher(),
      );
}
