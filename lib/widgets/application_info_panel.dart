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

import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/right_panel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationInfoPanel extends StatelessWidget {
  final Category? category;
  final App application;

  ApplicationInfoPanel({
    required this.category,
    required this.application,
  });

  @override
  Widget build(BuildContext context) => RightPanelDialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.memory(application.icon!, width: 50),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    application.name,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              application.packageName,
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
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
                  Icon(Icons.open_in_new),
                  Container(width: 8),
                  Text("Open", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () async {
                await context.read<AppsService>().launchApp(application);
                Navigator.of(context).pop(ApplicationInfoPanelResult.none);
              },
            ),
            if (category?.sort == CategorySort.manual)
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.open_with),
                    Container(width: 8),
                    Text("Reorder", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(ApplicationInfoPanelResult.reorderApp),
              ),
            TextButton(
              child: Row(
                children: [
                  Icon(application.hidden ? Icons.visibility : Icons.visibility_off_outlined),
                  Container(width: 8),
                  Text(application.hidden ? "Unhide" : "Hide", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () async {
                if (application.hidden) {
                  await context.read<AppsService>().unHideApplication(application);
                } else {
                  await context.read<AppsService>().hideApplication(application);
                }
                Navigator.of(context).pop(ApplicationInfoPanelResult.none);
              },
            ),
            if (category != null)
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined),
                    Container(width: 8),
                    Flexible(
                      child: Text(
                        "Remove from ${category!.name}",
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  await context.read<AppsService>().removeFromCategory(application, category!);
                  Navigator.of(context).pop(ApplicationInfoPanelResult.none);
                },
              ),
            Divider(),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.info_outlined),
                  Container(width: 8),
                  Text("App info", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () => context.read<AppsService>().openAppInfo(application),
            ),
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.delete_outlined),
                  Container(width: 8),
                  Text("Uninstall", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onPressed: () async {
                await context.read<AppsService>().uninstallApp(application);
                Navigator.of(context).pop(ApplicationInfoPanelResult.none);
              },
            ),
          ],
        ),
      );
}

enum ApplicationInfoPanelResult { none, reorderApp }
