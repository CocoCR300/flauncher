/*
 * FLauncher
 * Copyright (C) 2024 Oscar Rojas
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

class App
{
  final bool sideloaded;

  final String name;

  final String packageName;

  final String version;

  bool hidden;

  String? action;

  App({required this.packageName, required this.name, required this.version, required this.hidden, required this.sideloaded, this.action = null});

  App.fromSystem(Map<dynamic, dynamic> data):
    packageName = data['packageName'],
    name = data['name'],
    version = data['version'],
    hidden = false,
    sideloaded = data['sideloaded'] {

    if (data.containsKey('action')) {
      action = data['action'];
    }
  }
}