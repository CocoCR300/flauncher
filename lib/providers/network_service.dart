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

// https://developer.android.com/reference/android/telephony/TelephonyManager#NETWORK_TYPE_CDMA
enum CellularNetworkType
{
  Unknown,  // 0
  Gprs,     // 1
  Edge,     // 2
  Umts,     // 3
  Cdma,     // 4
  EvdoZero, // 5
  EvdoA,    // 6
  Unused_1, // 7
  Hsdpa,    // 8
  Hsupa,    // 9
  Hspa,     // 10
  Iden,     // 11
  EvdoB,    // 12
  Lte,      // 13
  Ehrpd,    // 14
  Hspap,    // 15
  Gsm,      // 16
  TdScdma,  // 17
  Iwlan,    // 18
  Unused_2, // 19
  Nr,       // 20
}

class NetworkService extends ChangeNotifier
{
  final FLauncherChannel  _channel;

  bool                _hasInternetAccess;
  CellularNetworkType _cellularNetworkType;
  NetworkType         _networkType;
  int                 _wirelessNetworkSignalLevel;


  NetworkService(this._channel) :
        _hasInternetAccess = false,
        _cellularNetworkType = CellularNetworkType.Unknown,
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

  bool                  get   hasInternetAccess             => _hasInternetAccess;
  CellularNetworkType   get   cellularNetworkType           => _cellularNetworkType;
  NetworkType           get   networkType                   => _networkType;
  int                   get   wirelessNetworkSignalLevel    => _wirelessNetworkSignalLevel;

  CellularNetworkType _getCellularNetworkType(int index)
  {
    CellularNetworkType type = CellularNetworkType.values[index];
    if (type == CellularNetworkType.Unused_1 || type == CellularNetworkType.Unused_2) {
      type = CellularNetworkType.Unknown;
    }

    return type;
  }

  void _getNetworkInformation(Map<String, dynamic> map)
  {
    int networkTypeInt = map["networkType"];
    _hasInternetAccess = map["internetAccess"];
    _networkType = NetworkType.values[networkTypeInt];

    if (_networkType == NetworkType.Cellular || _networkType == NetworkType.Wifi) {
      _wirelessNetworkSignalLevel = map["wirelessSignalLevel"];
    }
  }

  void _onNetworkChanged(Map<String, dynamic> event)
  {
    switch (event["name"]) {
      case "NETWORK_AVAILABLE":
        Map<dynamic, dynamic> map = event["arguments"];
        _getNetworkInformation(map.cast<String, dynamic>());
        break;
      case "NETWORK_UNAVAILABLE":
        _hasInternetAccess = false;
        _networkType = NetworkType.Unknown;
        break;
      case "CAPABILITIES_CHANGED":
        Map<dynamic, dynamic> map = event["arguments"];
        _getNetworkInformation(map.cast<String, dynamic>());
        break;
      case "CELLULAR_STATE_CHANGED":
        _cellularNetworkType = _getCellularNetworkType(event["arguments"]);
        notifyListeners();
        break;
    }

    notifyListeners();
  }
}