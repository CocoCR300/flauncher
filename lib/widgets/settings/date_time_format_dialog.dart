/*
 * FLauncher
 * Copyright (C) 2021  Oscar Rojas
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
import 'package:format/format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO: Translate these
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
];

const List<Tuple2<String, String>> timeFormatSpecifiers = [
  Tuple2("h", "[h] Hour in am/pm (1~12)"),
  Tuple2("H", "[H] Hour in day (0~23)"),
  Tuple2("m", "[m] Minute in hour (30)"),
  Tuple2("s", "[s] Second in minute (55)"),
  Tuple2("a", "[a] am/pm marker (PM)"),
  Tuple2("k", "[k] Hour in day (1~24)"),
  Tuple2("K", "[K] Hour in am/pm (0~11)")
];

class FormatModel extends ChangeNotifier {
  String _dateFormatString;
  String _timeFormatString;

  String get dateFormatString => _dateFormatString;
  String get timeFormatString => _timeFormatString;

  FormatModel(String dateFormatString, String timeFormatString) :
        _dateFormatString = dateFormatString,
        _timeFormatString = timeFormatString;

  void setDateFormatString(String newFormatString) {
    _dateFormatString = newFormatString;
    notifyListeners();
  }

  void setTimeFormatString(String newFormatString) {
    _timeFormatString = newFormatString;
    notifyListeners();
  }
}

class DateTimeFormatDialog extends StatelessWidget {
  final String _initialDateFormat;
  final String _initialTimeFormat;

  const DateTimeFormatDialog(String initialDateFormat, String initialTimeFormat, {super.key}) :
        _initialDateFormat = initialDateFormat,
        _initialTimeFormat = initialTimeFormat;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    TextEditingController dateFormatFieldController = TextEditingController(
        text: _initialDateFormat);
    TextEditingController timeFormatFieldController = TextEditingController(
        text: _initialTimeFormat);

    List<DropdownMenuEntry<String>> menuEntries = [];

    Iterable<Tuple2<String, String>> formatSpecifiers =
      dateFormatSpecifiers.followedBy(timeFormatSpecifiers);
    for (Tuple2<String, String> tuple in formatSpecifiers) {
      menuEntries.add(DropdownMenuEntry(value: tuple.item1, label: tuple.item2));
    }

    return ChangeNotifierProvider(
      create: (_) => FormatModel(_initialDateFormat, _initialTimeFormat),
      builder: (context, _) => SimpleDialog(
        insetPadding: const EdgeInsets.only(bottom: 60),
        contentPadding: const EdgeInsets.all(24),
        title: Text(localizations.dateAndTimeFormat),
        children: [
          Consumer<FormatModel>(
            builder: (_, model, __) {
              String text;

              if (model.dateFormatString.isEmpty) {
                text = localizations.noDateFormatSpecified;
              }
              else {
                DateFormat dateFormat = DateFormat(
                    model.dateFormatString, Platform.localeName);
                text = localizations.formattedDate(dateFormat.format(DateTime.now()));
              }

              if (model.timeFormatString.isEmpty) {
                text += "\n${localizations.noTimeFormatSpecified}";
              }
              else {
                DateFormat dateFormat = DateFormat(
                    model.timeFormatString, Platform.localeName);
                text += "\n${localizations.formattedTime(dateFormat.format(DateTime.now()))}";
              }

              return Text(text);
            }
          ),
          const SizedBox(height: 24),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: dateFormatFieldController,
            decoration: InputDecoration(labelText: localizations.typeInTheDateFormat),
            keyboardType: TextInputType.text,
            onChanged: (value) => dateFormatStringChanged(context, value),
            onFieldSubmitted: (value) {
              returnFromDialog(context, value, timeFormatFieldController.text);
            },
            validator: (value) {
              String? result;

              if (value != null) {
                value = value.trim();

                if (value.isEmpty) {
                  result = localizations.mustNotBeEmpty;
                }
              }

              return result;
            },
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: timeFormatFieldController,
            decoration: InputDecoration(labelText: localizations.typeInTheHourFormat),
            keyboardType: TextInputType.text,
            onChanged: (value) => timeFormatStringChanged(context, value),
            onFieldSubmitted: (value) {
              returnFromDialog(context, dateFormatFieldController.text, value);
            },
            validator: (value) {
              String? result;

              if (value != null) {
                value = value.trim();

                if (value.isEmpty) {
                  result = localizations.mustNotBeEmpty;
                }
              }

              return result;
            },
          ),
          const SizedBox(height: 24),
          Text(localizations.orSelectFormatSpecifiers),
          const SizedBox(height: 12),
          DropdownMenu<String>(
              dropdownMenuEntries: menuEntries,
              onSelected: (selectedValue) {
                if (selectedValue != null) {
                  bool isTimeFormat = false;

                  for (Tuple2<String, String> tuple in timeFormatSpecifiers) {
                    if (tuple.item1 == selectedValue) {
                      isTimeFormat = true;
                      break;
                    }
                  }

                  if (isTimeFormat) {
                    timeFormatFieldController.text += selectedValue;
                    timeFormatStringChanged(context, timeFormatFieldController.text);
                  }
                  else {
                    dateFormatFieldController.text += selectedValue;
                    dateFormatStringChanged(context, dateFormatFieldController.text);
                  }
                }
              }
          )
        ],
      )
    );
  }

  void dateFormatStringChanged(BuildContext context, String formatString) {
    FormatModel model = Provider.of<FormatModel>(context, listen: false);
    model.setDateFormatString(formatString);
  }

  void timeFormatStringChanged(BuildContext context, String formatString) {
    FormatModel model = Provider.of<FormatModel>(context, listen: false);
    model.setTimeFormatString(formatString);
  }

  void returnFromDialog(BuildContext context, String dateFormatString, String timeFormatString) {
    dateFormatString = dateFormatString.trim();
    timeFormatString = timeFormatString.trim();

    if (dateFormatString.isNotEmpty && timeFormatString.isNotEmpty) {
      Navigator.pop(context, Tuple2(dateFormatString, timeFormatString));
    }
  }
}
