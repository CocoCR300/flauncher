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
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/widgets/settings/back_button_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SoundFeedbackDirectionalFocusAction extends DirectionalFocusAction {
  final BuildContext context;

  SoundFeedbackDirectionalFocusAction(this.context);

  @override
  void invoke(DirectionalFocusIntent intent) {
    super.invoke(intent);

    SettingsService settingsService = context.read<SettingsService>();
    if (settingsService.appKeyClickEnabled) {
      Feedback.forTap(context);
    } else {
      silentForTap(context);
    }
  }

  /// copied from Feedback.forTap, omitting playing a sound
  static void silentForTap(BuildContext context) async {
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
  }
}

class BackAction extends Action<BackIntent> {
  final BuildContext context;

  BackAction(this.context);

  @override
  Future<void> invoke(BackIntent intent) async {
    AppsService appsService = context.read<AppsService>();
    LauncherState launcherState = context.read<LauncherState>();
    SettingsService settingsService = context.read<SettingsService>();
    NavigatorState? navigator = Navigator.maybeOf(context);

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return;
    }

    if (kDebugMode || await isDefaultLauncher(context)) {
      String action = settingsService.backButtonAction;

      switch (action) {
        case BACK_BUTTON_ACTION_CLOCK:
          launcherState.toggleLauncherVisibility();
          break;
        case BACK_BUTTON_ACTION_SCREENSAVER:
          appsService.startAmbientMode();
          break;
      }
    }
    else {
      SystemNavigator.pop();
    }
  }
}

class BackIntent extends Intent {
  const BackIntent();
}

Future<bool> isDefaultLauncher(BuildContext context) async => await context.read<AppsService>().isDefaultLauncher();
