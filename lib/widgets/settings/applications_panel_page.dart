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
import 'package:flauncher/widgets/add_to_category_dialog.dart';
import 'package:flauncher/widgets/application_info_panel.dart';
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationsPanelPage extends StatefulWidget {
  static const String routeName = "applications_panel";

  @override
  State<ApplicationsPanelPage> createState() => _ApplicationsPanelPageState();
}

class _ApplicationsPanelPageState extends State<ApplicationsPanelPage> {
  String _title = "TV Applications";

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Text(_title, style: Theme.of(context).textTheme.headline6),
            Divider(),
            Material(
              type: MaterialType.transparency,
              child: TabBar(
                onTap: (index) {
                  switch (index) {
                    case 0:
                      setState(() => {_title = "TV Applications"});
                      break;
                    case 1:
                      setState(() => {_title = "Non-TV Applications"});
                      break;
                    case 2:
                      setState(() => {_title = "Hidden Applications"});
                      break;
                    default:
                      throw ArgumentError.value(index, "index");
                  }
                },
                tabs: [
                  Tab(icon: Icon(Icons.tv)),
                  Tab(icon: Icon(Icons.android)),
                  Tab(icon: Icon(Icons.visibility_off_outlined)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(child: TabBarView(children: [_TVTab(), _SideloadedTab(), _HiddenTab()])),
          ],
        ),
      );
}

class _TVTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Selector<AppsService, List<App>>(
        selector: (_, appsService) => appsService.applications.where((app) => !app.sideloaded && !app.hidden).toList(),
        builder: (context, applications, _) => ListView(
          children: applications
              .map((application) => EnsureVisible(alignment: 0.5, child: _appCard(context, application)))
              .toList(),
        ),
      );
}

class _SideloadedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Selector<AppsService, List<App>>(
        selector: (_, appsService) => appsService.applications.where((app) => app.sideloaded && !app.hidden).toList(),
        builder: (context, applications, _) => ListView(
          children: applications
              .map((application) => EnsureVisible(alignment: 0.5, child: _appCard(context, application)))
              .toList(),
        ),
      );
}

class _HiddenTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Selector<AppsService, List<App>>(
        selector: (_, appsService) => appsService.applications.where((app) => app.hidden).toList(),
        builder: (context, applications, _) => ListView(
          children: applications
              .map((application) => EnsureVisible(alignment: 0.5, child: _appCard(context, application)))
              .toList(),
        ),
      );
}

Widget _appCard(BuildContext context, App application) => Card(
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
            if (!application.hidden)
              IconButton(
                constraints: BoxConstraints(),
                splashRadius: 20,
                icon: Icon(Icons.add_box_outlined),
                onPressed: () => showDialog<Category>(
                  context: context,
                  builder: (_) => AddToCategoryDialog(application),
                ),
              ),
            IconButton(
              constraints: BoxConstraints(),
              splashRadius: 20,
              icon: Icon(Icons.info_outline),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ApplicationInfoPanel(
                  category: null,
                  application: application,
                ),
              ),
            ),
          ],
        ),
      ),
    );
