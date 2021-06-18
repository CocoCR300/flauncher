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

import 'package:flauncher/flauncher_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("getInstalledApplications", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "getInstalledApplications") {
        return [
          {'packageName': 'me.efesser.flauncher'}
        ];
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    final apps = await fLauncherChannel.getInstalledApplications();

    expect(apps, [
      {'packageName': 'me.efesser.flauncher'}
    ]);
  });

  test("launchApp", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    String? packageName;
    String? className;
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "launchApp") {
        final arguments = call.arguments as List<Object?>;
        packageName = arguments[0] as String;
        className = arguments[1] as String;
        return;
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    await fLauncherChannel.launchApp("me.efesser.flauncher", ".MainActivity");

    expect(packageName, "me.efesser.flauncher");
    expect(className, ".MainActivity");
  });

  test("openSettings", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    bool called = false;
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "openSettings") {
        called = true;
        return;
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    await fLauncherChannel.openSettings();

    expect(called, isTrue);
  });

  test("openAppInfo", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    String? packageName;
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "openAppInfo") {
        packageName = call.arguments as String;
        return;
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    await fLauncherChannel.openAppInfo("me.efesser.flauncher");

    expect(packageName, "me.efesser.flauncher");
  });

  test("uninstallApp", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    String? packageName;
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "uninstallApp") {
        packageName = call.arguments as String;
        return;
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    await fLauncherChannel.uninstallApp("me.efesser.flauncher");

    expect(packageName, "me.efesser.flauncher");
  });

  test("isDefaultLauncher", () async {
    final channel = MethodChannel('me.efesser.flauncher/method');
    channel.setMockMethodCallHandler((call) async {
      if (call.method == "isDefaultLauncher") {
        return true;
      }
      fail("Unhandled method name");
    });
    final fLauncherChannel = FLauncherChannel();

    final isDefaultLauncher = await fLauncherChannel.isDefaultLauncher();

    expect(isDefaultLauncher, isTrue);
  });
}
