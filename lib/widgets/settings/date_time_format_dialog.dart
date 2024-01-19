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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

const List<Tuple2<String, String>> dateFormatSpecifiers = [
  Tuple2("d", "[d] Day in month (10)"),
  Tuple2("E", "[E] Abbreviated day of week (Tue)"),
  Tuple2("EEEE", "[EEEE] Day of week (Tuesday)"),
  Tuple2("D", "[D] Day in year (189)"),
  // Tuple2("c", "Standalone day", "10"),
  Tuple2("M", "[M] Month in year (07)"),
  Tuple2("MMM", "[MMM] Abbreviated month in year (Jul)"),
  Tuple2("MMMM", "[MMMM] Month in year (July)"),
  // Tuple2("L", "Standalone month", "07 or July"),
  Tuple2("y", "[y] Year (1996)"),
  Tuple2("h", "[h] Hour in am/pm (1~12)"),
  Tuple2("H", "[H] Hour in day (0~23)"),
  Tuple2("m", "[m] Minute in hour (30)"),
  Tuple2("s", "[s] Second in minute (55)"),
  Tuple2("a", "[a] am/pm marker (PM)"),
  Tuple2("k", "[k] Hour in day (1~24)"),
  Tuple2("K", "[K] Hour in am/pm (0~11)")
];

class FormatModel extends ChangeNotifier {
  String _formatString;

  String get formatString => _formatString;

  FormatModel(String? formatString) : _formatString = formatString ?? "";

  void set(String newFormatString) {
    _formatString = newFormatString;
    notifyListeners();
  }
}

class DateTimeFormatDialog extends StatelessWidget {
  final String? _initialFormat;

  DateTimeFormatDialog({
    String? initialValue,
  }) : _initialFormat = initialValue;

  @override
  Widget build(BuildContext context) {
    TextEditingController formatFieldController = TextEditingController(
        text: _initialFormat);

    List<DropdownMenuEntry<String>> menuEntries = [];

    for (Tuple2<String, String> tuple in dateFormatSpecifiers) {
      menuEntries.add(DropdownMenuEntry(value: tuple.item1, label: tuple.item2));
    }

    return ChangeNotifierProvider(
      create: (_) => FormatModel(_initialFormat),
      builder: (context, _) => SimpleDialog(
        insetPadding: EdgeInsets.only(bottom: 60),
        contentPadding: EdgeInsets.all(24),
        title: Text("Date and time format"),
        children: [
          Consumer<FormatModel>(
            builder: (_, model, __) {
              String text;

              if (model.formatString.isEmpty) {
                text = "Result: No format specified";
              }
              else {
                DateFormat dateFormat = DateFormat(
                    model.formatString, Platform.localeName);
                text = "Result: ${dateFormat.format(DateTime.now())}";
              }

              return Text(text);
            }
          ),
          SizedBox(height: 24),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: formatFieldController,
            decoration: InputDecoration(labelText: "Type in a format"),
            keyboardType: TextInputType.text,
            onChanged: (value) => dateFormatStringChanged(context, value),
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pop(context, value);
              }
            },
            validator: (value) {
              String? result;

              if (value != null) {
                value = value.trim();

                if (value.isEmpty) {
                  result = "Must not be empty";
                }
              }

              return result;
            },
          ),
          SizedBox(height: 24),
          Text("Or select format specifiers:"),
          SizedBox(height: 12),
          DropdownMenu<String>(
              dropdownMenuEntries: menuEntries,
              onSelected: (selectedValue) {
                if (selectedValue != null) {
                  formatFieldController.text += selectedValue;
                  dateFormatStringChanged(context, formatFieldController.text);
                }
              }
          )
        ],
      )
    );
  }

  void dateFormatStringChanged(BuildContext context, String dateFormatString) {
    FormatModel model = Provider.of<FormatModel>(context, listen: false);
    model.set(dateFormatString);
  }
}
