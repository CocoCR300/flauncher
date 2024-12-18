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

import 'dart:async';

import 'package:flauncher/providers/apps_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';

class _SettingsState extends ChangeNotifier
{
  void Function()? onSave;

  late bool changed;
  late bool creating;
  late bool valid;
  late LauncherSectionType sectionType;

  _SettingsState(LauncherSection? launcherSection)
  {
    changed = false;
    creating = false;
    valid = false;
    sectionType = LauncherSectionType.Category;

    if (launcherSection == null) {
      creating = true;
    }
    else if (launcherSection is LauncherSpacer) {
      sectionType = LauncherSectionType.Spacer;
    }

    valid = false;
    changed = creating;
  }

  void setFlags(bool valid, bool changed)
  {
    if (this.valid != valid || this.changed != changed) {
      this.valid = valid;
      this.changed = changed;

      notifyListeners();
    }
  }

  void setSectionType(LauncherSectionType sectionType)
  {
    if (this.sectionType != sectionType) {
      this.sectionType = sectionType;

      if (creating && sectionType == LauncherSectionType.Spacer) {
        changed = true;
        valid = true;
      }

      notifyListeners();
    }
  }
}

class LauncherSectionPanelPage extends StatelessWidget
{
  static const String routeName = "section_panel";

  final int? sectionId;

  LauncherSectionPanelPage({Key? key, this.sectionId}): super(key: key);

  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Selector<AppsService, LauncherSection?>(
      selector: (_, appsService) => _launcherSectionSelector(appsService, sectionId),
      builder: (_, launcherSection, __) => ChangeNotifierProvider(
        create: (_) => _SettingsState(launcherSection),
        builder: (context, _) => Selector<_SettingsState, LauncherSectionType>(
          selector: (context, state) => state.sectionType,
          builder: (context, sectionType, _) {
            _SettingsState state = context.read();
            bool creating = state.creating;
            Widget sectionSpecificSettings;

            if (sectionType == LauncherSectionType.Category) {
              sectionSpecificSettings = _CategorySettings(
                  category: launcherSection as Category?,
                  onChanged: (valid, dirty, name, sort, type, columns, rowHeight) {
                    state.setFlags(valid, dirty);
                  }
              );
            }
            else {
              sectionSpecificSettings = _LauncherSpacerSettings(
                  spacer: launcherSection as LauncherSpacer?
              );
            }

            String title = localizations.newSection;
            if (!creating) {
              title = localizations.modifySection;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (creating)
                          _listTile(
                            context,
                            Text(localizations.type),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: DropdownButton<LauncherSectionType>(
                                value: sectionType,
                                onChanged: (value) {
                                  state.setSectionType(value!);
                                },
                                isDense: true,
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                    value: LauncherSectionType.Category,
                                    child: Text(localizations.category, style: Theme.of(context).textTheme.bodySmall)
                                  ),
                                  DropdownMenuItem(
                                    value: LauncherSectionType.Spacer,
                                    child: Text(localizations.spacer, style: Theme.of(context).textTheme.bodySmall)
                                  )
                                ]
                              )
                            )
                          ),

                        sectionSpecificSettings,
                      ]
                    )
                  )
                ),
                Divider(),
                Selector<_SettingsState, bool>(
                  selector: (context, state) => (state.valid && state.changed),
                  builder: (context, canSave, _) {
                    void Function()? onSavePressed = null;
                    if (canSave) {
                      onSavePressed = () {
                        if (state.onSave != null) {
                          state.onSave!();
                        }
                      };
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                        child: Text(localizations.save),
                        onPressed: onSavePressed
                      )
                    );
                  }
                ),

                if (!creating)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                      child: Text(localizations.delete),
                      onPressed: () async {
                        await context.read<AppsService>().deleteSection(launcherSection!);
                        Navigator.of(context).pop();
                      }
                    )
                  )
                ]
            );
          }
        )
      )
    );
  }
}

class _CategorySettings extends StatefulWidget
{
  final Category? category;
  final void Function(bool valid, bool dirty, String, CategorySort, CategoryType, int columnsCount, int rowHeight)? onChanged;

  const _CategorySettings({
    this.category,
    this.onChanged
  });

  @override
  State<StatefulWidget> createState() => _CategorySettingsState();
}

class _CategorySettingsState extends State<_CategorySettings>
{
  CategorySort _categorySort;
  CategoryType _categoryType;
  int _columnsCount;
  int _rowHeight;
  String _name;

  late Category? _category;

  late bool _creating;
  late TextEditingController _nameController;

  _CategorySettingsState():
        _categorySort = Category.Sort,
        _categoryType = Category.Type,
        _columnsCount = Category.ColumnsCount,
        _rowHeight = Category.RowHeight,
        _name = "";

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _category = widget.category;
    _creating = _category == null;

    if (!_creating) {
      _name = _category!.name;
      _categorySort = _category!.sort;
      _categoryType = _category!.type;
      _columnsCount = _category!.columnsCount;
      _rowHeight = _category!.rowHeight;
    }

    _nameController = TextEditingController(text: _name);

    _SettingsState state = context.read();
    state.onSave = _save;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        _listTile(
          context,
          Text(localizations.name),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              setState(() {
                _name = value;
              });
              _notifyChange();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return localizations.mustNotBeEmpty;
              }

              return null;
            }
          )
        ),
        _listTile(
          context,
          Text(localizations.sort),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: DropdownButton<CategorySort>(
              isDense: true,
              isExpanded: true,
              value: _categorySort,
              onChanged: (value) {
                setState(() {
                  _categorySort = value!;
                });
                _notifyChange();
              },
              items: [
                DropdownMenuItem(
                  value: CategorySort.alphabetical,
                  child: Text(localizations.alphabetical, style: Theme.of(context).textTheme.bodySmall),
                ),
                DropdownMenuItem(
                  value: CategorySort.manual,
                  child: Text(localizations.manual, style: Theme.of(context).textTheme.bodySmall),
                )
              ]
            )
          )
        ),
        _listTile(
          context,
          Text(localizations.layout),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: DropdownButton<CategoryType>(
              value: _categoryType,
              onChanged: (value) {
                setState(() {
                  _categoryType = value!;
                });
                _notifyChange();
              },
              isDense: true,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: CategoryType.row,
                  child: Text(localizations.row, style: Theme.of(context).textTheme.bodySmall)
                ),
                DropdownMenuItem(
                  value: CategoryType.grid,
                  child: Text(localizations.grid, style: Theme.of(context).textTheme.bodySmall)
                )
              ]
            )
          )
        ),
        if (_categoryType == CategoryType.grid)
          _listTile(
            context,
            Text(localizations.columnCount),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: DropdownButton<int>(
                value: _columnsCount,
                isDense: true,
                isExpanded: true,
                items: [for (int i = 5; i <= 10; i++) i]
                    .map(
                      (value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _columnsCount = value!;
                  });
                  _notifyChange();
                }
              )
            )
          ),
        if (_categoryType == CategoryType.row)
          _listTile(
            context,
            Text(localizations.rowHeight),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: DropdownButton<int>(
                value: _rowHeight,
                isDense: true,
                isExpanded: true,
                items: [for (int i = 80; i <= 150; i += 10) i]
                    .map(
                      (value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _rowHeight = value!;
                  });
                  _notifyChange();
                }
              )
            )
          )
      ]
    );
  }

  void _notifyChange()
  {

    String initialName = "";
    CategorySort initialSort = Category.Sort;
    CategoryType initialType = Category.Type;
    int initialColumnsCount = Category.ColumnsCount;
    int initialRowHeight = Category.RowHeight;
    if (_category != null) {
      initialName = _category!.name;
      initialSort = _category!.sort;
      initialType = _category!.type;
      initialColumnsCount = _category!.columnsCount;
      initialRowHeight = _category!.rowHeight;
    }

    bool dirty = initialSort != _categorySort || initialType != _categoryType
        || initialColumnsCount != _columnsCount
        || initialRowHeight != _rowHeight || initialName != _name ;

    _SettingsState state = context.read();
    state.setFlags(_name.isNotEmpty, dirty);
  }

  Future<void> _save() async
  {
    final AppsService service = context.read();
    if (_creating) {
      await service.addCategory(_name, sort: _categorySort, type: _categoryType,
          columnsCount: _columnsCount, rowHeight: _rowHeight
      );
    }
    else {
      await service.updateCategory(_category!.id, _name, _categorySort,
          _categoryType, _columnsCount, _rowHeight
      );
    }

    _notifyChange();
  }
}

class _LauncherSpacerSettings extends StatefulWidget
{
  final LauncherSpacer? spacer;

  const _LauncherSpacerSettings({this.spacer});

  @override
  State<StatefulWidget> createState() => _LauncherSpacerSettingsState();
}

class _LauncherSpacerSettingsState extends State<_LauncherSpacerSettings>
{
  bool _valid;

  int? _numberValue;
  LauncherSpacer? _spacer;

  late bool _creating;
  late TextEditingController _valueController;

  _LauncherSpacerSettingsState(): _valid = true;

  @override
  void initState() {
    super.initState();

    _spacer = widget.spacer;
    _creating = _spacer == null;

    int height = 10;
    if (_spacer != null) {
      height = _spacer!.height;
    }

    _valueController = TextEditingController(text: height.toString());
    context.read<_SettingsState>().onSave = _save;
  }

  @override
  void dispose() {
    super.dispose();

    _valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return _listTile(
      context,
      Text(localizations.height),
      Padding(
        padding: EdgeInsets.only(top: 4),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          controller: _valueController,
          keyboardType: TextInputType.numberWithOptions(),
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            setState(() {
              _numberValue = int.tryParse(value);
              _valid = _numberValue != null && _numberValue! > 0 && _numberValue! < 500;

              _notifyChange();
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return localizations.mustNotBeEmpty;
            }

            if (!_valid) {
              return localizations.spacerMaxHeightRequirement;
            }

            return null;
          }
        )
      )
    );
  }

  void _notifyChange()
  {
    context.read<_SettingsState>().setFlags(_valid, _numberValue != _spacer?.height);
  }

  Future<void> _save() async
  {
    AppsService service = context.read();
    assert(_numberValue != null);
    if (_creating) {
      await service.addSpacer(_numberValue!);
    }
    else {
      assert(_spacer != null);
      await service.updateSpacerHeight(_spacer!, _numberValue!);
    }

    _notifyChange();
  }
}

Widget _listTile(BuildContext context, Widget title, Widget subtitle, {Widget? trailing}) => Material(
    type: MaterialType.transparency,
    child: ListTile(
      dense: true,
      minVerticalPadding: 8,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    )
);

LauncherSection? _launcherSectionSelector(AppsService appsService, int? sectionId)
{
  if (sectionId == null) {
    return null;
  }

  LauncherSection? spacer;
  int index = appsService.launcherSections.indexWhere((s) => s.id == sectionId);

  if (index != -1) {
    spacer = appsService.launcherSections[index];
  }

  return spacer;
}

