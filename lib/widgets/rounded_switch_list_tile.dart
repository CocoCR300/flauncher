
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? title;
  final Widget? secondary;

  const RoundedSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    // for now require the title and secondary
    required this.title,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton( // all of this crap is to style the SwitchListTile like a TextButton
      onPressed: () => onChanged!(!value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              secondary!,
              Container(width: 8),
              title!
            ]
          ),
          Container(
            // TODO: this isn't very flexible
            constraints: BoxConstraints(maxHeight: 16),
            child: Switch(
              value: value,
              onChanged: onChanged,
            )
          ),
        ],
      ),
    );
  }
}
