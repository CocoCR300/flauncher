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
        IconData iconData = Icons.mobiledata_off;

        switch (networkService.networkType)
        {
          case NetworkType.Cellular:
            switch (networkService.cellularNetworkType)
            {
              case CellularNetworkType.Cdma || CellularNetworkType.Gsm || CellularNetworkType.Gprs:
                iconData = Icons.g_mobiledata;

              case CellularNetworkType.Edge: iconData = Icons.e_mobiledata;

              case CellularNetworkType.Hspa || CellularNetworkType.Hsdpa || CellularNetworkType.Hsupa:
                iconData = Icons.h_mobiledata;

              case CellularNetworkType.Hspap: iconData = Icons.h_plus_mobiledata;

              case CellularNetworkType.Umts || CellularNetworkType.TdScdma:
                iconData = Icons.three_g_mobiledata; break;

              case CellularNetworkType.Lte: iconData = Icons.four_g_mobiledata_outlined; break;
              case CellularNetworkType.Nr: iconData = Icons.five_g;

              default: iconData = Icons.question_mark; break;
            }
            break;
          case NetworkType.Wifi:
            iconData = Icons.wifi;

            int signalLevel = networkService.wirelessNetworkSignalLevel;
            if (signalLevel == 0) {
              iconData = Icons.wifi_1_bar;
            }
            else if (signalLevel == 1) {
              iconData = Icons.wifi_2_bar;
            }
            break;
          case NetworkType.Vpn: iconData = Icons.vpn_key; break;
          case NetworkType.Wired: iconData = Icons.lan; break;
          case NetworkType.Unknown: iconData = Icons.link_off; break;
        }

        return Icon(iconData,
          shadows: const [
           Shadow(
             color: Colors.black54,
             offset: Offset(0, 2),
             blurRadius: 8
           )
          ]
        );
      }
    );
  }
}