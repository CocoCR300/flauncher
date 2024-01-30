package me.efesser.flauncher;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class NetworkUtils
{
    public static final String KEY_INTERNET_ACCESS = "internetAccess";
    public static final String KEY_NETWORK_ACCESS = "networkAccess";
    public static final String KEY_NETWORK_TYPE = "networkType";
    public static final String KEY_WIRELESS_SIGNAL_LEVEL = "wirelessSignalLevel";

    public static Map<String, Object> getNetworkCapabilitiesInformation(NetworkCapabilities capabilities)
    {
        boolean hasNetworkAccess, hasInternetAccess;
        int wirelessNetworkSignalLevel = 0;
        short networkType = 4; // Align with NetworkType enum value indices, on file lib/providers/network_service.dart

        hasNetworkAccess = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            hasInternetAccess = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED);
        }
        else {
            hasInternetAccess = hasNetworkAccess;
        }

        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
            networkType = 0;
            // TODO: Get signal level
        }
        else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
            networkType = 1;
        }
        else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
            networkType = 2;
        }
        else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
            networkType = 3;
        }

        return Map.of(
                KEY_NETWORK_ACCESS, hasNetworkAccess,
                KEY_INTERNET_ACCESS, hasInternetAccess,
                KEY_NETWORK_TYPE, networkType,
                KEY_WIRELESS_SIGNAL_LEVEL, wirelessNetworkSignalLevel);
    }

    public static Map<String, Object> getNetworkInformation(ConnectivityManager connectivityManager, WifiManager wifiManager, Network network)
    {
        Map<String, Object> map = null;
        int wirelessNetworkSignalLevel = 0;

        NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);

        if (capabilities != null) {
            map = getNetworkCapabilitiesInformation(capabilities);

            if (Objects.equals(map.get(KEY_NETWORK_TYPE), 1)) {
                wirelessNetworkSignalLevel = getWifiSignalLevel(wifiManager);
            }
        }

        if (map != null) {
            map = new HashMap<>(map);
        }
        else {
            map = new HashMap<>();
        }

        map.put(KEY_WIRELESS_SIGNAL_LEVEL, wirelessNetworkSignalLevel);

        return map;
    }

    public static Map<String, Object> getNetworkInformation(@Nullable NetworkInfo networkInfo)
    {
        boolean hasNetworkAccess = false;
        int networkType = 4, networkInfoType;

        if (networkInfo != null) {
            hasNetworkAccess = networkInfo.isConnected();
            networkInfoType = networkInfo.getType();

            // Align with NetworkType enum value indices, on file lib/providers/network_service.dart
            if (networkInfoType <= ConnectivityManager.TYPE_WIFI) {
                networkType = networkInfoType;
            }
            else if (networkInfoType == ConnectivityManager.TYPE_VPN) {
                networkType = 2;
            }
            else if (networkInfoType == ConnectivityManager.TYPE_ETHERNET) {
                networkType = 3;
            }
        }

        return Map.of(
                KEY_NETWORK_TYPE, networkType,
                KEY_NETWORK_ACCESS, hasNetworkAccess,
                KEY_INTERNET_ACCESS, hasNetworkAccess);
    }

    public static int getWifiSignalLevel(WifiManager wifiManager)
    {
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        int rssi = wifiInfo.getRssi();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            return wifiManager.calculateSignalLevel(rssi);
        }
        else {
            final int SIGNAL_LEVELS = 5; // Not based on anything in particular
            //noinspection deprecation
            return WifiManager.calculateSignalLevel(rssi, SIGNAL_LEVELS);
        }
    }
}
