/*
 * FLauncher
 * Copyright (C) 2024 Oscar Rojas 
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';

class LauncherSpacerPanelPage extends StatefulWidget
{
  static const String routeName = "spacer_panel";

  final int spacerId;

  LauncherSpacerPanelPage({Key? key, required this.spacerId}):
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LauncherSpacerPanelPageState();
}

class _LauncherSpacerPanelPageState extends State<LauncherSpacerPanelPage>
{
  bool valid;
  
  int height;

  late TextEditingController valueController;

  _LauncherSpacerPanelPageState(): valid = false, height = 10
  {
  }

  @override
  void initState() {
    super.initState();

    LauncherSection? launcherSection = _launcherSectionSelector(context.read<AppsService>());
    if (launcherSection is LauncherSpacer) {
      height = launcherSection.height;
    }

    valueController = TextEditingController(text: height.toString());
  }

  @override
  void dispose() {
    super.dispose();

    valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Selector<AppsService, LauncherSpacer?>(
      selector: (_, appsService) => _launcherSectionSelector(appsService),
      builder: (_, spacer, __) {
        if (spacer == null) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(localizations.modifySpacer, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            Divider(),
            _listTile(
              context,
              Text(localizations.height),
              Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: valueController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return localizations.mustNotBeEmpty;
                      }

                      int? numberValue = int.tryParse(value);
                      if (numberValue == null || numberValue == 0 || numberValue > 500) {
                        return localizations.spacerMaxHeightRequirement;
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.numberWithOptions(),
                    textCapitalization: TextCapitalization.sentences,
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: valueController,
                builder: (context, value, _) {
                  String text = value.text;
                  int? numberValue = int.tryParse(text);
                  bool valid = text.isNotEmpty && numberValue != null && numberValue != 0 && numberValue <= 500;

                  void Function()? onSavePressed = null;
                  if (valid && spacer.height != numberValue) {
                    onSavePressed = () async {
                      await context.read<AppsService>().updateSpacerHeight(
                          spacer, numberValue
                      );
                      // Force a refresh
                      valueController.text = text;
                    };
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                    child: Text(localizations.save),
                    onPressed: onSavePressed
                  );
                }
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                child: Text(localizations.delete),
                onPressed: () async {
                  await context.read<AppsService>().deleteSection(spacer);
                  Navigator.of(context).pop();
                }
              )
            )
          ]
        );
      }
    );
  }
  
  LauncherSpacer? _launcherSectionSelector(AppsService appsService) {
    LauncherSpacer? spacer;
    int index = appsService.launcherSections.indexWhere((s) => s.id == widget.spacerId);

    if (index == -1) {
      spacer = null;
    } else {
      spacer = appsService.launcherSections[index] as LauncherSpacer;
    }

    return spacer;
  }

  Widget _listTile(BuildContext context, Widget title, Widget subtitle, {Widget? trailing}) => Material(
    type: MaterialType.transparency,
    child: ListTile(
      dense: true,
      minVerticalPadding: 8,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    ),
  );
}
