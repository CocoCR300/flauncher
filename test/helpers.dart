import 'package:flauncher/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Element? findAppCardByPackageName(WidgetTester tester, String packageName) {
  for (var val in tester.elementList(find.byType(AppCard))) {
    if ((val.widget as AppCard).application.packageName == packageName) {
      return val;
    }
  }
  return null;
}

Element? findSettingsIcon(WidgetTester tester) {
  // this function seems strange, but this is the simplest way I had to find the settings icon button
  for (var val in tester.elementList(find.byIcon(Icons.settings_outlined))) {
    if (((val as StatelessElement).widget as Icon).color == null) {
      return val;
    }
  }
  return null;
}
