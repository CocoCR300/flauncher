import 'package:flauncher/widgets/color_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Should compute 2 next border color", () {
    // given
    double tick1 = 0.3;
    double tick2 = 0.5;
    Color defaultColor = Colors.red;

    // when
    var color1 = computeBorderColor(tick1, defaultColor);
    var color2 = computeBorderColor(tick2, defaultColor);

    // then
    expect(color1, isNot(isSameColorAs(color2)));
    expect(color2, isNot(isSameColorAs(defaultColor)));
    expect(color1, isNot(isSameColorAs(defaultColor)));
  });

  test("Should return default value", () {
    // given
    double tick = 1;
    Color defaultColor = Colors.red;

    // when
    var color = computeBorderColor(tick, defaultColor);

    // then
    expect(color, isSameColorAs(defaultColor));
  });

  test("Should accept value between 0 and 1", () {
    // given
    double badTick1 = 1.1;
    double badTick2 = -0.1;
    Color defaultColor = Colors.red;

    // then
    expect(() => computeBorderColor(badTick1, defaultColor), throwsAssertionError);
    expect(() => computeBorderColor(badTick2, defaultColor), throwsAssertionError);
  });
}
