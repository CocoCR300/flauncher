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

import 'package:flauncher/actions.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'flauncher.dart';

class FLauncherApp extends StatelessWidget
{
  static const PrioritizedIntents _backIntents = PrioritizedIntents(orderedIntents: [
    DismissIntent(),
    BackIntent()
  ]);

  static const MaterialColor _swatch = MaterialColor(0xFF011526, <int, Color>{
    50: Color(0xFF36A0FA),
    100: Color(0xFF067BDE),
    200: Color(0xFF045CA7),
    300: Color(0xFF033662),
    400: Color(0xFF022544),
    500: Color(0xFF011526),
    600: Color(0xFF000508),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });

  const FLauncherApp();

  @override
  Widget build(BuildContext context) {
    AppsService appsService = context.read<AppsService>();
    LauncherState launcherState = context.read<LauncherState>();
    launcherState.refresh(appsService);

    return MaterialApp(
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.escape): _backIntents,
        const SingleActivator(LogicalKeyboardKey.gameButtonB): _backIntents,
        const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent()
      },
      actions: {
        ...WidgetsApp.defaultActions,
        BackIntent: BackAction(context),
        DirectionalFocusIntent: SoundFeedbackDirectionalFocusAction(context)
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'FLauncher',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: _swatch,
        cardColor: _swatch[300],
        canvasColor: _swatch[300],
        dialogBackgroundColor: _swatch[400],
        scaffoldBackgroundColor: _swatch[400],
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.white)),
        appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
        typography: Typography.material2018(),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          labelStyle: Typography.material2018().white.bodyMedium,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: _swatch[200],
          selectionHandleColor: _swatch[200],
        ),
      ),
      home: Builder(
        builder: (context) => PopScope(
          canPop: false,
          child: FLauncher(),
          onPopInvoked: (didPop) {
            LauncherState launcherState = context.read<LauncherState>();
            launcherState.handleBackNavigation(context);
          }
        )
      ),
    );
  }
}
