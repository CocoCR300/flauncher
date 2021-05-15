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

import 'package:flauncher/application_info.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/scaling_button.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final ApplicationInfo application;
  final FocusNode focusNode;
  final bool autofocus;

  AppCard({
    required this.application,
    required this.focusNode,
    required this.autofocus,
  });

  @override
  Widget build(BuildContext context) => ScalingButton(
        scale: 1.1,
        focusNode: focusNode,
        autofocus: autofocus,
        onPressed: () {
          FLauncherChannel.startActivity(application.packageName);
        },
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return Opacity(
              opacity: hasFocus ? 1 : 0.8,
              child: SizedBox.expand(
                child: Card(
                  elevation: hasFocus ? 4 : 0,
                  clipBehavior: Clip.antiAlias,
                  child: application.banner != null
                      ? Image.memory(application.banner!, fit: BoxFit.cover)
                      : Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              child: Image.memory(
                                application.icon!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Flexible(child: Text(application.name))
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      );
}
