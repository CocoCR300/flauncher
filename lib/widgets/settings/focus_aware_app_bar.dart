import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_service.dart';
import '../date_time_widget.dart';
import '../network_widget.dart';

class FocusAwareAppBar extends StatefulWidget implements PreferredSizeWidget
{
  @override
  State<StatefulWidget> createState() {
    return _FocusAwareAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FocusAwareAppBarState extends State<FocusAwareAppBar>
{
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        this.setState(() {
          focused = hasFocus;
        });
      },
      child: AnimatedContainer(
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 250),
        height: focused ? kToolbarHeight : 0,
        child: AppBar(
          actions: [
            IconButton(
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(),
              splashRadius: 20,
              icon: const Icon(Icons.settings_outlined,
                shadows: [
                  Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))
                ],
              ),
              onPressed: () => showDialog(context: context, builder: (_) => const SettingsPanel()),
              // sometime after Flutter 3.7.5, no later than 3.16.8, the focus highlight went away
              focusColor: Theme.of(context).primaryColorLight,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: NetworkWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 32),
              child: Selector<SettingsService,
                  ({
                    bool showDateInStatusBar,
                    bool showTimeInStatusBar,
                    String dateFormat,
                    String timeFormat })>(
                selector: (context, service) => (
                showDateInStatusBar: service.showDateInStatusBar,
                showTimeInStatusBar: service.showTimeInStatusBar,
                dateFormat: service.dateFormat,
                timeFormat: service.timeFormat),
                builder: (context, dateTimeSettings, _) {
                  // TODO: Disabling the "show date" option while both are enabled causes the *time* to disappear,
                  // then re-enabling that same option causes the time to appear twice.
                  // A restart (or just changing to the full screen clock) fixes the issue, but why does this happen?
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dateTimeSettings.showDateInStatusBar)
                        Flexible(
                            child: DateTimeWidget(dateTimeSettings.dateFormat,
                              updateInterval: const Duration(minutes: 1),
                              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                                shadows: [
                                  const Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 8)
                                ],
                              ),
                            )
                        ),
                      if (dateTimeSettings.showDateInStatusBar && dateTimeSettings.showTimeInStatusBar)
                        const SizedBox(width: 16),
                      if (dateTimeSettings.showTimeInStatusBar)
                        Flexible(
                          child: DateTimeWidget(dateTimeSettings.timeFormat,
                            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                              shadows: [
                                const Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 8)
                              ],
                            )
                          )
                        )
                    ]
                  );
                },
              ),
            ),
          ],
        )
      )
    );
  }
}