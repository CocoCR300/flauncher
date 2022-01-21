import 'package:flutter/material.dart';

/// Compute a color for a border (grey based), based on the provided value.
/// The value must be between 0 and 1, otherwise an assertion error is raised.
/// The provided defaultValue is the color returned in case
/// the function cannot find a grey color.
Color computeBorderColor(double value, Color defaultValue) {
  assert(value >= 0 && value <= 1);
  // we are converting a number with a value of [0, 1] to a multiple of 100
  int val = (value * 10).round() * 100;
  Color? color = val == 0 ? Colors.white : Colors.grey[val];
  return color ?? defaultValue;
}
