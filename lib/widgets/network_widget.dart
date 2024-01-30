import 'package:flauncher/providers/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkWidget extends StatelessWidget
{
  const NetworkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, networkService, _) {
        IconData iconData;

        switch (networkService.networkType)
        {
          case NetworkType.Cellular: iconData = Icons.network_cell; break;
          case NetworkType.Wifi: iconData = Icons.wifi; break;
          case NetworkType.Vpn: iconData = Icons.vpn_key; break;
          case NetworkType.Wired: iconData = Icons.lan; break;
          case NetworkType.Unknown: iconData = Icons.signal_wifi_connected_no_internet_4; break;
        }

        return Icon(iconData,
          shadows: const [
           Shadow(
             color: Colors.black54,
             offset: Offset(0, 2),
             blurRadius: 4
           )
          ]
        );
      }
    );
  }
}