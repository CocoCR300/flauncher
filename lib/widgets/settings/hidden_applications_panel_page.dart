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
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HiddenApplicationsPanelPage extends StatelessWidget {
  static const String routeName = "hidden_applications_panel";

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text("Hidden applications", style: Theme.of(context).textTheme.headline6),
          Divider(),
          Selector<AppsService, List<App>>(
            selector: (_, appsService) => appsService.hiddenApplications,
            builder: (context, hiddenApplications, _) => Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: hiddenApplications.isNotEmpty
                        ? hiddenApplications
                            .map(
                              (application) => EnsureVisible(
                                alignment: 0.5,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                    title: Text(
                                      application.name,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: Image.memory(application.icon!, height: 48),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          constraints: BoxConstraints(),
                                          splashRadius: 20,
                                          icon: Icon(Icons.open_in_new),
                                          onPressed: () => context.read<AppsService>().launchApp(application),
                                        ),
                                        IconButton(
                                          constraints: BoxConstraints(),
                                          splashRadius: 20,
                                          icon: Icon(Icons.visibility),
                                          onPressed: () => context.read<AppsService>().unHideApplication(application),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList()
                        : [SizedBox(height: 16), Text("Nothing to see here.")]),
              ),
            ),
          ),
        ],
      );
}
