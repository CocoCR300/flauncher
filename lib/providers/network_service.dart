/*
 * FLauncher
 * Copyright (C) 2021  Oscar Rojas
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
import 'package:flutter/material.dart';

enum NetworkType
{
  Cellular,
  Wifi,
  Vpn,
  Wired,
  Unknown
}

class NetworkService extends ChangeNotifier
{
  FLauncherChannel  _channel;
  NetworkType       _networkType;
  int               _wirelessNetworkSignalLevel;

  NetworkService(this._channel) :
        _networkType = NetworkType.Unknown,
        _wirelessNetworkSignalLevel = 0
  {
    _channel.addNetworkChangedListener(_onNetworkChanged);

    _channel
        .getActiveNetworkInformation()
        .then((map) {
          if (map.isNotEmpty) {
            // If handle is present, there is a network and all keys should correspond to actual values
            if (map.containsKey("handle")) {
              int networkTypeInt = map["networkType"];
              _networkType = networkTypeInt == -1 ? NetworkType.Unknown : NetworkType.values[networkTypeInt];
              _wirelessNetworkSignalLevel = map["wirelessNetworkSignalLevel"];
            }
          }
        });
  }

  NetworkType   get   networkType                   => _networkType;
  int           get   wirelessNetworkSignalLevel    => _wirelessNetworkSignalLevel;

  void _onNetworkChanged(Map<String, dynamic> event)
  {
    switch (event["name"]) {
      case "NETWORK_AVAILABLE":
        break;
      case "CAPABILITIES_CHANGED":
        break;
      default:
        break;
    }

    notifyListeners();
  }
}