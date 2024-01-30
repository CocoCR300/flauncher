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
  final FLauncherChannel  _channel;

  bool              _hasInternetAccess;
  NetworkType       _networkType;
  int               _wirelessNetworkSignalLevel;

  NetworkService(this._channel) :
        _hasInternetAccess = false,
        _networkType = NetworkType.Unknown,
        _wirelessNetworkSignalLevel = 0
  {
    _channel.addNetworkChangedListener(_onNetworkChanged);

    _channel
        .getActiveNetworkInformation()
        .then((map) {
          if (map.isNotEmpty) {
            _getNetworkInformation(map);
          }
        });
  }

  bool          get   hasInternetAccess             => _hasInternetAccess;
  NetworkType   get   networkType                   => _networkType;
  int           get   wirelessNetworkSignalLevel    => _wirelessNetworkSignalLevel;

  void _getNetworkInformation(Map<String, dynamic> map)
  {
    int networkTypeInt = map["networkType"];
    _hasInternetAccess = map["internetAccess"];
    _networkType = NetworkType.values[networkTypeInt];
  }

  void _onNetworkChanged(Map<String, dynamic> event)
  {
    switch (event["name"]) {
      case "NETWORK_AVAILABLE":
        _getNetworkInformation(event);
        break;
      case "NETWORK_UNAVAILABLE":
        _hasInternetAccess = false;
        _networkType = NetworkType.Unknown;
        break;
      case "CAPABILITIES_CHANGED":
        _getNetworkInformation(event);
        break;
    }

    notifyListeners();
  }
}