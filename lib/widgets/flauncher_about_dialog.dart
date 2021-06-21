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
import 'package:package_info_plus/package_info_plus.dart';

class FLauncherAboutDialog extends StatelessWidget {
  final PackageInfo packageInfo;

  FLauncherAboutDialog({
    Key? key,
    required this.packageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2!;
    final underlined = textStyle.copyWith(decoration: TextDecoration.underline);
    return AboutDialog(
      applicationName: packageInfo.appName,
      applicationVersion: "${packageInfo.version} (${packageInfo.buildNumber})",
      applicationIcon: Image.asset("assets/logo.png", height: 72),
      applicationLegalese: "© 2021 Étienne Fesser",
      children: [
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: textStyle,
            children: [
              TextSpan(
                text: "FLauncher is an open-source alternative launcher for Android TV.\n"
                    "Source code available at ",
              ),
              TextSpan(text: "https://gitlab.com/etiennf01/flauncher", style: underlined),
              TextSpan(text: ".\n\n"),
              TextSpan(text: "Logo by Katie "),
              TextSpan(text: "@fureturoe", style: underlined),
              TextSpan(text: ", "),
              TextSpan(text: "design by "),
              TextSpan(text: "@FXCostanzo", style: underlined),
              TextSpan(text: "."),
            ],
          ),
        )
      ],
    );
  }
}
