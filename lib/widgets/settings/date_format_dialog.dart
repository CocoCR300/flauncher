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

class DateTimeModel extends ChangeNotifier {
  String dateTime;

  DateTimeModel(String initialDateTime) : dateTime = initialDateTime;

  void set(String newDateTime) {
    dateTime = newDateTime;
    notifyListeners();
  }
}

class DateFormatDialog extends StatelessWidget {
  final String? _initialFormat;

  DateFormatDialog({
    String? initialValue,
  }) : _initialFormat = initialValue;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
        text: _initialFormat);

    List<DropdownMenuEntry<String>> menuEntries = [];

    for (Tuple2<String, String> tuple in dateFormatSpecifiers) {
      menuEntries.add(DropdownMenuEntry(value: tuple.item1, label: tuple.item2));
    }

    return ChangeNotifierProvider(
      create: (_) => DateTimeModel(
          DateFormat(_initialFormat).format(DateTime.now())
      ),
      builder: (context, _) => SimpleDialog(
        insetPadding: EdgeInsets.only(bottom: 60),
        contentPadding: EdgeInsets.all(24),
        title: Text("Date and time format"),
        children: [
          Consumer<DateTimeModel>(
            builder: (_, model, __) {
              String text;

              if (model.dateTime.isEmpty) {
                text = "Result: No format specified";
              }
              else {
                text = "Result ${model.dateTime}";
              }

              return Text(text);
            }
          ),
          SizedBox(height: 24),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: controller,
            decoration: InputDecoration(labelText: "Type in a format"),
            keyboardType: TextInputType.text,
            onChanged: (value) => dateTimeFormatChanged(context, value),
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.of(context).pop(value);
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
                  controller.text += selectedValue;
                  dateTimeFormatChanged(context, controller.text);
                }
              }
          )
        ],
      )
    );
  }

  void dateTimeFormatChanged(BuildContext context, String dateFormat) {
    DateTimeModel model = Provider.of<DateTimeModel>(context, listen: false);

    if (dateFormat.isNotEmpty) {
      String dateTime = DateFormat(dateFormat).format(DateTime.now());
      model.set(dateTime);
    }
    else {
      model.set("");
    }
  }
}
