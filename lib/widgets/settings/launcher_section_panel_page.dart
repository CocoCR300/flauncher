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

class LauncherSectionPanelPage extends StatefulWidget
{
  static const String routeName = "section_panel";

  final int? sectionId;

  LauncherSectionPanelPage({Key? key, this.sectionId}):
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LauncherSectionPanelPageState();
}

class _LauncherSectionPanelPageState extends State<LauncherSectionPanelPage>
{
  final StreamController _streamController;

  LauncherSection? _launcherSection;

  bool _changed;
  bool _valid;
  LauncherSectionType _sectionType;

  _LauncherSectionPanelPageState():
        _streamController = StreamController.broadcast(),
        _sectionType = LauncherSectionType.Category,
        _changed = false,
        _valid = true;

  @override
  void initState() {
    super.initState();

    _launcherSection = _launcherSectionSelector(context.read<AppsService>(), widget.sectionId);
    if (_launcherSection is LauncherSpacer) {
      _sectionType = LauncherSectionType.Spacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    Widget sectionSpecificSettings;
    if (_sectionType == LauncherSectionType.Category) {
      sectionSpecificSettings = _CategorySettings(
          category: _launcherSection as Category?,
          onChanged: (valid, dirty, name, sort, type, columns, rowHeight) {
            setState(() {
              _valid = valid;
              _changed = dirty;
            });
          },
          requestSave: _streamController.stream
      );
    }
    else {
      sectionSpecificSettings = _LauncherSpacerSettings(
          spacer: _launcherSection as LauncherSpacer?,
          onChanged: (valid, dirty, height) {
            setState(() {
              _valid = valid;
              _changed = dirty;
            });
          },
          requestSave: _streamController.stream
      );
    }

    return Selector<AppsService, LauncherSection?>(
      selector: (_, appsService) => _launcherSectionSelector(appsService, widget.sectionId),
      builder: (_, launcherSection, __) {
        bool creating = launcherSection == null;
        void Function()? onSavePressed = null;

        if (creating) {
          if (_sectionType == LauncherSectionType.Category) {
            _valid = false;
          }
          _changed = true;
        }

        if (_valid && _changed) {
          onSavePressed = () {
            _streamController.sink.add(null);
          };
        }

        String title = "New section";
        if (!creating) {
          title = "Modify section";
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
                                value: _sectionType,
                                onChanged: (value) {
                                  setState(() {
                                    _sectionType = value!;
                                  });
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                child: Text(localizations.save),
                onPressed: onSavePressed
              )
            ),

            if (!creating)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                  child: Text(localizations.delete),
                  onPressed: () async {
                    await context.read<AppsService>().deleteSection(launcherSection);
                    Navigator.of(context).pop();
                  }
                )
              )
          ]
        );
      }
    );
  }
}

class _CategorySettings extends StatefulWidget
{
  final Category? category;
  final void Function(bool valid, bool dirty, String, CategorySort, CategoryType, int columnsCount, int rowHeight)? onChanged;
  final Stream? requestSave;

  const _CategorySettings({
    this.category,
    this.onChanged,
    this.requestSave
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
  late void Function(bool valid, bool dirty, String, CategorySort, CategoryType, int columnsCount, int rowHeight)? _onChanged;
  late StreamSubscription? _requestSave;

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
    _requestSave?.cancel();
  }

  @override
  void initState() {
    super.initState();

    _category = widget.category;
    _creating = _category == null;
    _onChanged = widget.onChanged;
    _requestSave = widget.requestSave?.listen((_) => _save());

    if (!_creating) {
      _name = _category!.name;
      _categorySort = _category!.sort;
      _categoryType = _category!.type;
      _columnsCount = _category!.columnsCount;
      _rowHeight = _category!.rowHeight;
    }

    _nameController = TextEditingController(text: _name);
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
            Column(
              children: [
                SizedBox(height: 4),
                DropdownButton<CategorySort>(
                  value: _categorySort,
                  onChanged: (value) {
                    setState(() {
                      _categorySort = value!;
                    });
                    _notifyChange();
                  },
                  isDense: true,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: CategorySort.alphabetical,
                      child: Text(localizations.alphabetical, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: CategorySort.manual,
                      child: Text(localizations.manual, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _listTile(
            context,
            Text(localizations.layout),
            Column(
              children: [
                SizedBox(height: 4),
                DropdownButton<CategoryType>(
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
                      child: Text(localizations.row, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: CategoryType.grid,
                      child: Text(localizations.grid, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_categoryType == CategoryType.grid)
            _listTile(
              context,
              Text(localizations.columnCount),
              Column(
                children: [
                  SizedBox(height: 4),
                  DropdownButton<int>(
                    value: _columnsCount,
                    isDense: true,
                    isExpanded: true,
                    items: [for (int i = 5; i <= 10; i++) i]
                        .map(
                          (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _columnsCount = value!;
                      });
                      _notifyChange();
                    },
                  ),
                ],
              ),
            ),
          if (_categoryType == CategoryType.row)
            _listTile(
              context,
              Text(localizations.rowHeight),
              Column(
                children: [
                  SizedBox(height: 4),
                  DropdownButton<int>(
                    value: _rowHeight,
                    isDense: true,
                    isExpanded: true,
                    items: [for (int i = 80; i <= 150; i += 10) i]
                        .map(
                          (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString(), style: Theme.of(context).textTheme.bodySmall),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _rowHeight = value!;
                      });
                      _notifyChange();
                    },
                  ),
                ],
              ),
            ),
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

    if (_onChanged != null) {
      bool dirty = initialSort != _categorySort || initialType != _categoryType
          || initialColumnsCount != _columnsCount
          || initialRowHeight != _rowHeight || initialName != _name ;
      _onChanged!(_name.isNotEmpty, dirty, _name, _categorySort, _categoryType, _columnsCount, _rowHeight);
    }
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
      await service.updateCategory(_category!.id, _categorySort, _categoryType,
        _columnsCount, _rowHeight
      );
    }
  }
}

class _LauncherSpacerSettings extends StatefulWidget
{
  final LauncherSpacer? spacer;
  final void Function(bool valid, bool dirty, int? height)? onChanged;
  final Stream? requestSave;

  const _LauncherSpacerSettings({
    this.spacer,
    this.onChanged,
    this.requestSave
  });

  @override
  State<StatefulWidget> createState() => _LauncherSpacerSettingsState();
}

class _LauncherSpacerSettingsState extends State<_LauncherSpacerSettings>
{
  bool _valid;

  int? _numberValue;
  LauncherSpacer? _spacer;
  void Function(bool valid, bool dirty, int? height)? _onChanged;
  StreamSubscription? _requestSave;

  late bool _creating;
  late TextEditingController _valueController;

  _LauncherSpacerSettingsState(): _valid = true;

  @override
  void initState() {
    super.initState();

    _spacer = widget.spacer;
    _creating = _spacer == null;
    _onChanged = widget.onChanged;
    _requestSave = widget.requestSave?.listen((_) => _save());

    int height = 10;
    if (_spacer != null) {
      height = _spacer!.height;
    }

    _valueController = TextEditingController(text: height.toString());
  }

  @override
  void dispose() {
    super.dispose();

    _valueController.dispose();
    _requestSave?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return _listTile(
      context,
      Text(localizations.height),
      Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: _valueController,
            keyboardType: TextInputType.numberWithOptions(),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              setState(() {
                _numberValue = int.tryParse(value);
                _valid = _numberValue != null && _numberValue! > 0 && _numberValue! < 500;

                if (_onChanged != null) {
                  _onChanged!(_valid, _numberValue != _spacer?.height, _numberValue);
                }
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
        ]
      )
    );
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

