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
        scale: 1.15,
        focusNode: focusNode,
        autofocus: autofocus,
        onPressed: () => FLauncherChannel.launchApp(application),
        child: Builder(
          builder: (context) => Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: _borderRadius(),
                    color: Theme.of(context).backgroundColor),
                clipBehavior: Clip.antiAlias,
                child: application.banner != null
                    ? Image.memory(application.banner!)
                    : Row(
                        children: [
                          Image.memory(application.icon!),
                          Expanded(
                            child: Text(
                              application.name,
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: _borderRadius(),
                  color: Colors.black
                      .withOpacity(Focus.of(context).hasFocus ? 0 : 0.25),
                ),
              ),
            ],
          ),
        ),
      );

  BorderRadius _borderRadius() => BorderRadius.circular(16);
}
