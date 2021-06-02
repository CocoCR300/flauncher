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

import 'dart:ui';

import 'package:flauncher/application_info.dart';
import 'package:flauncher/apps.dart';
import 'package:flauncher/widgets/long_press_detector.dart';
import 'package:flauncher/widgets/tv_ink_well_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AppCard extends StatefulWidget {
  final ApplicationInfo application;
  final bool autofocus;

  AppCard({
    required this.application,
    required this.autofocus,
  });

  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) => LongPressDetector(
        onPressed: () => _onPressed(context),
        onLongPressed: () => _onLongPressed(context),
        child: Builder(
          builder: (context) => AnimatedContainer(
            duration: Duration(milliseconds: 100),
            transformAlignment: Alignment.center,
            transform: Transform.scale(
              scale: Focus.of(context).hasFocus ? 1.15 : 1.0,
            ).transform,
            child: Stack(
              children: [
                TVInkWellCard(
                  autofocus: widget.autofocus,
                  onPressed: () => _onPressed(context),
                  onLongPress: () => _onLongPressed(context),
                  child: widget.application.banner != null
                      ? Ink.image(
                          image: MemoryImage(widget.application.banner!),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Ink.image(
                                  image: MemoryImage(widget.application.icon!),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.application.name,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
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
      );

  void _onPressed(BuildContext context) =>
      context.read<Apps>().launchApp(widget.application);

  void _onLongPressed(BuildContext context) => showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => _ApplicationInfoPanel(
          application: widget.application,
        ),
      );
}

class _ApplicationInfoPanel extends StatelessWidget {
  final ApplicationInfo application;

  _ApplicationInfoPanel({
    required this.application,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        elevation: 24,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[900],
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Image.memory(
                      application.icon!,
                      width: 50,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          application.name,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    application.packageName,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "v${application.version}",
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                ),
                Divider(),
                TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      Container(width: 8),
                      Text(
                        "App info",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  onPressed: () =>
                      context.read<Apps>().openAppInfo(application),
                ),
                TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      Container(width: 8),
                      Text(
                        "Uninstall",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await context.read<Apps>().uninstallApp(application);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
