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

import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/modify_launcher_section_dialog.dart';
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flauncher/widgets/settings/category_panel_page.dart';
import 'package:flauncher/widgets/settings/launcher_spacer_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';

class CategoriesPanelPage extends StatelessWidget {
  static const String routeName = "categories_panel";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
        children: [
          Text(localizations.categories, style: Theme.of(context).textTheme.titleLarge),
          Divider(),
          Selector<AppsService, List<LauncherSection>>(
            selector: (_, appsService) => appsService.launcherSections,
            builder: (_, sections, __) => Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: sections.indexed.map((tuple) {
                    int index = tuple.$1;
                    bool last = index == sections.length - 1;

                    return _section(context, sections[index], index, last);
                  }).toList(),
                ),
              ),
            ),
          ),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text("Add section"),
            onPressed: () async {
              final dialogResult = await showDialog<ModifyLauncherSectionDialogResult>(
                  context: context,
                  builder: (_) => ModifyLauncherSectionDialog()
              );
              if (dialogResult != null) {
                AppsService service = context.read();
                if (dialogResult.type == LauncherSectionType.Category) {
                  await service.addCategory(dialogResult.value);
                }
                else {
                  await service.addSpacer(int.parse(dialogResult.value));
                }
              }
            },
          ),
        ],
      );
  }

  Widget _section(BuildContext context, LauncherSection section, int index, bool last) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    String title = localizations.spacer;
    if (section is Category) {
      title = section.name;
      
      if (title == localizations.spacer) {
        title = localizations.disambiguateCategoryTitle(title);
      }
    }
    
    return Padding(
      //key: Key(section.order.toString()),
      padding: EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: EnsureVisible(
          alignment: 0.5,
          child: ListTile(
            dense: true,
            title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  constraints: BoxConstraints(),
                  splashRadius: 20,
                  icon: Icon(Icons.arrow_upward),
                  onPressed: index > 0 ? () => _move(context, index, index - 1) : null,
                ),
                IconButton(
                  constraints: BoxConstraints(),
                  splashRadius: 20,
                  icon: Icon(Icons.arrow_downward),
                  onPressed: last ? null : () => _move(context, index, index + 1),
                ),
                IconButton(
                  constraints: BoxConstraints(),
                  splashRadius: 20,
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    final NavigatorState navigator = Navigator.of(context);
                    if (section is Category) {
                      navigator.pushNamed(
                        CategoryPanelPage.routeName,
                        arguments: section.id,
                      );
                    }
                    else {
                      navigator.pushNamed(
                        LauncherSpacerPanelPage.routeName,
                        arguments: section.id
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _move(BuildContext context, int oldIndex, int newIndex) async {
    await context.read<AppsService>().moveSection(oldIndex, newIndex);
  }
}
