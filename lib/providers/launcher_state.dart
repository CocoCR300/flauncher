import 'package:flutter/foundation.dart';

class LauncherState extends ChangeNotifier
{
  bool _launcherVisible;

  bool  get launcherVisible => _launcherVisible;

  LauncherState() : _launcherVisible = true;

  void toggleLauncherVisibility() {
    _launcherVisible = !_launcherVisible;
    notifyListeners();
  }
}