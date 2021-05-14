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

import 'package:flauncher/ApplicationInfo.dart';
import 'package:flauncher/DateTimeWidget.dart';
import 'package:flauncher/PackageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FLauncher extends StatefulWidget {
  @override
  _FLauncherState createState() => _FLauncherState();
}

class _FLauncherState extends State<FLauncher> {
  List<ApplicationInfo> _applications;
  FocusNode _topFocusNode;

  @override
  void initState() {
    super.initState();
    _topFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final installedApps = await PackageManager.getInstalledApplications();
      setState(() {
        _applications = installedApps;
      });
    });
  }

  @override
  void dispose() {
    _topFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              child: Builder(
                builder: (context) => Transform.scale(
                  scale: Focus.of(context).hasFocus ? 1.2 : 1,
                  child: Icon(Icons.settings_outlined),
                ),
              ),
              onPressed: () => PackageManager.openSettings(),
            ),
            VerticalDivider(width: 24),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: DateTimeWidget(),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Focus(child: Container(height: 80), focusNode: _topFocusNode),
              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  "Applications",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              _applications == null
                  ? Center(child: CircularProgressIndicator())
                  : GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 16 / 9,
                      crossAxisCount: 5,
                      children: _applications.map((e) => _card(e)).toList(),
                    ),
            ],
          ),
        ),
      );

  Widget _card(ApplicationInfo app) => RawKeyboardListener(
        onKey: (value) {
          if (value is RawKeyUpEvent &&
                  value.logicalKey == LogicalKeyboardKey.select ||
              value.logicalKey == LogicalKeyboardKey.enter) {
            PackageManager.startActivity(app.packageName);
          }
        },
        focusNode: FocusNode(),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Builder(
            builder: (context) {
              final hasFocus = Focus.of(context).hasFocus;
              return Transform.scale(
                scale: hasFocus ? 1.1 : 1,
                child: Opacity(
                  opacity: hasFocus ? 1 : 0.6,
                  child: Card(
                    elevation: hasFocus ? 4 : 0,
                    clipBehavior: Clip.antiAlias,
                    child: app.banner != null
                        ? Image.memory(app.banner, fit: BoxFit.fitWidth)
                        : Row(children: [
                            if (app.icon != null)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Image.memory(app.icon,
                                    fit: BoxFit.fitWidth),
                              ),
                            Flexible(child: Text(app.name))
                          ]),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
