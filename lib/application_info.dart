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

import 'dart:typed_data';

class ApplicationInfo {
  String name;
  String packageName;
  String className;
  String version;
  Uint8List? banner;
  Uint8List? icon;
  bool? _favorite;

  bool get favorited => _favorite!;

  set favorited(bool value) => _favorite = value;

  ApplicationInfo(
    this.name,
    this.packageName,
    this.className,
    this.version,
    this.banner,
    this.icon,
  );

  factory ApplicationInfo.create(dynamic data) => ApplicationInfo(
        data["name"],
        data["packageName"],
        data["className"],
        data["version"],
        data["banner"],
        data["icon"],
      );
}
