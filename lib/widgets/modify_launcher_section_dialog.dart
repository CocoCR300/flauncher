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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/category.dart';

class ModifyLauncherSectionDialogResult
{
  final LauncherSectionType type;
  final String value;

  const ModifyLauncherSectionDialogResult({
    required this.type,
    required this.value
  });
}

class ModifyLauncherSectionDialog extends StatefulWidget
{
  final String? initialValue;
  final LauncherSectionType type;

  const ModifyLauncherSectionDialog({
    super.key,
    this.type = LauncherSectionType.Category,
    this.initialValue = null
  });

  @override
  State<StatefulWidget> createState() => _ModifyLauncherSectionDialogState();
}

class _ModifyLauncherSectionDialogState extends State<ModifyLauncherSectionDialog>
{
  late final bool creating;

  late bool valid;
  late LauncherSectionType type;
  late TextEditingController valueController;

  _ModifyLauncherSectionDialogState()
  {
    valid = false;
  }

  @override
  void initState() {
    super.initState();

    creating = widget.initialValue == null;
    type = widget.type;
    valueController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    super.dispose();

    valueController.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    String dialogTitle = "Add section";
    if (!creating) {
      dialogTitle = "Modify section";
    }

    String inputFieldTitle = localizations.name;
    TextInputType inputType = TextInputType.text;
    if (type == LauncherSectionType.Spacer) {
      inputFieldTitle = localizations.height;
      inputType = TextInputType.numberWithOptions();
    }

    return SimpleDialog(
      insetPadding: EdgeInsets.only(bottom: 120),
      contentPadding: EdgeInsets.all(24),
      title: Text(dialogTitle),
      children: [
        if (creating)
          DropdownButton<LauncherSectionType>(
            value: type,
            onChanged: (value) {
              setState(() {
                type = value!;
                valueController.clear();
              });
            },
            isDense: true,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: LauncherSectionType.Category,
                child: Text("Category", style: Theme.of(context).textTheme.bodySmall),
              ),
              DropdownMenuItem(
                value: LauncherSectionType.Spacer,
                child: Text(localizations.spacer, style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        
        TextFormField(
          autofocus: !creating,
          controller: valueController,
          decoration: InputDecoration(labelText: inputFieldTitle),
          initialValue: widget.initialValue,
          validator: (value) {
            String trimmed = value!.trim();
            if (trimmed.isEmpty) {
              valid = false;
              return localizations.mustNotBeEmpty;
            }

            int? numberValue;
            if (type == LauncherSectionType.Spacer && ((numberValue = int.tryParse(trimmed)) == null || numberValue == 0 || numberValue! > 500)) {
              valid = false;
              return localizations.spacerMaxHeightRequirement;
            }

            valid = true;
            return null;
          },
          autovalidateMode: AutovalidateMode.always,
          keyboardType: inputType,
          textCapitalization: TextCapitalization.sentences,
          onFieldSubmitted: (value) {
            if (valid) {
              Navigator.of(context).pop(
                  ModifyLauncherSectionDialogResult(type: type, value: value)
              );
            }
          }
        )
      ]
    );
  }
}
