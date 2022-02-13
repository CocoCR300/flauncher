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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SoundFeedbackDirectionalFocusAction extends DirectionalFocusAction {
  final BuildContext context;

  SoundFeedbackDirectionalFocusAction(this.context);

  @override
  void invoke(DirectionalFocusIntent intent) {
    super.invoke(intent);
    Feedback.forTap(context);
  }
}

class BackAction extends Action<BackIntent> {
  final BuildContext context;
  final bool systemNavigator;

  BackAction(this.context, {this.systemNavigator = false});

  @override
  Future<void> invoke(BackIntent intent) async {
    if (systemNavigator && await shouldPopScope(context)) {
      SystemNavigator.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }
}

class BackIntent extends Intent {
  const BackIntent();
}

Future<bool> shouldPopScope(BuildContext context) async => !await context.read<AppsService>().isDefaultLauncher();
