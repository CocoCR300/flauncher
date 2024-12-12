import 'package:flutter/material.dart';

class RoundedSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget title;
  final Widget secondary;

  const RoundedSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onChanged(!value),
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        child: Row(
          children: [
            secondary,
            SizedBox(width: 8),
            Expanded(child: title),
            SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 16),
              child: Switch(
                value: value,
                onChanged: onChanged,
              )
            ),
          ],
        )
      ),
    );
  }
}
