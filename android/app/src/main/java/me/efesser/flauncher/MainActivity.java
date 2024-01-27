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

package me.efesser.flauncher;

import android.content.Intent;
import android.content.pm.*;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.UserHandle;
import android.provider.Settings;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import java.io.ByteArrayOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity
{
    private final String METHOD_CHANNEL = "me.efesser.flauncher/method";
    private final String APPS_EVENT_CHANNEL = "me.efesser.flauncher/event_apps";
    private final String NETWORK_EVENT_CHANNEL = "me.efesser.flauncher/event_network";

    ArrayList<LauncherApps.Callback> _launcherAppsCallbacks;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine)
    {
        super.configureFlutterEngine(flutterEngine);

        _launcherAppsCallbacks = new ArrayList<>();
        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

        new MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler((call, result) -> {
            switch (call.method)
            {
                case "getApplications" -> result.success(getApplications());
                case "applicationExists" -> result.success(applicationExists((String) call.arguments));
                case "launchApp" -> result.success(launchApp((String) call.arguments));
                case "openSettings" -> result.success(openSettings());
                case "openAppInfo" -> result.success(openAppInfo((String) call.arguments));
                case "uninstallApp" -> result.success(uninstallApp((String) call.arguments));
                case "isDefaultLauncher" -> result.success(isDefaultLauncher());
                case "checkForGetContentAvailability" -> result.success(checkForGetContentAvailability());
                case "startAmbientMode" -> result.success(startAmbientMode());
                case "getActiveNetworkInformation" -> result.success(getActiveNetworkInformation());
                default -> throw new IllegalArgumentException();
            }
        });

        new EventChannel(messenger, APPS_EVENT_CHANNEL).setStreamHandler(
                new LauncherAppsEventStreamHandler());

        new EventChannel(messenger, NETWORK_EVENT_CHANNEL).setStreamHandler(
                new NetworkEventStreamHandler());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        LauncherApps launcherApps = (LauncherApps) getSystemService(LAUNCHER_APPS_SERVICE);

        for (LauncherApps.Callback callback : _launcherAppsCallbacks) {
            launcherApps.unregisterCallback(callback);
        }
    }

    private List<Map<String, Serializable>> getApplications() {
        List<ResolveInfo> tvActivitiesInfo = queryIntentActivities(false);
        List<ResolveInfo> nonTvActivitiesInfo = queryIntentActivities(true);

        List<Map<String, Serializable>> applications = new ArrayList<>(
                tvActivitiesInfo.size() + nonTvActivitiesInfo.size());

        for (ResolveInfo tvActivityInfo : tvActivitiesInfo) {
            applications.add(buildAppMap(tvActivityInfo.activityInfo, false));
        }

        for (ResolveInfo nonTvActivityInfo : nonTvActivitiesInfo) {
            boolean nonDuplicate = true;

            for (ResolveInfo tvActivityInfo : tvActivitiesInfo) {
                if (tvActivityInfo.activityInfo.packageName.equals(nonTvActivityInfo.activityInfo.packageName)) {
                    nonDuplicate = false;
                    break;
                }

            }

            if (nonDuplicate) {
                buildAppMap(nonTvActivityInfo.activityInfo, true);
            }
        }
        return applications;
    }

    private Map<String, Serializable> getApplication(String packageName) {
        Map<String, Serializable> map = Map.of();
        PackageManager packageManager = getPackageManager();
        Intent intent = packageManager.getLeanbackLaunchIntentForPackage(packageName);

        if (intent != null) {
            intent = packageManager.getLaunchIntentForPackage(packageName);
        }

        if (intent != null) {
            ActivityInfo activityInfo = intent.resolveActivityInfo(getPackageManager(), 0);

            if (activityInfo != null) {
                map = buildAppMap(activityInfo, false);
            }
        }

        return map;
    }

    private boolean applicationExists(String packageName) {
        int flags;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            flags = PackageManager.MATCH_UNINSTALLED_PACKAGES;
        } else {
            flags = PackageManager.GET_UNINSTALLED_PACKAGES;
        }

        try {
            getPackageManager().getApplicationInfo(packageName, flags);
            return true;
        } catch (PackageManager.NameNotFoundException ignored) {
            return false;
        }
    }

    private List<ResolveInfo> queryIntentActivities(boolean sideloaded) {
        Intent intent;
        String category;
        if (sideloaded) {
            category = Intent.CATEGORY_LAUNCHER;
        }
        else {
            category = Intent.CATEGORY_LEANBACK_LAUNCHER;
        }

        // NOTE: Would be nice to query the applications that match *either* of the above categories
        // but from the addCategory function documentation, it says that it will "use activities
        // that provide *all* the requested categories"
        intent = new Intent(Intent.ACTION_MAIN, null)
                        .addCategory(category);

       List<ResolveInfo> resolveInfoList = getPackageManager()
               .queryIntentActivities(intent, 0);

       return resolveInfoList;
    }

    private Map<String, Serializable> buildAppMap(ActivityInfo activityInfo, boolean sideloaded) {
        PackageManager packageManager = getPackageManager();

        byte[] bannerBytes = new byte[0], iconBytes = new byte[0];
        Drawable banner = activityInfo.loadBanner(packageManager);
        Drawable icon = activityInfo.loadIcon(packageManager);
        String applicationVersionName = "";

        if (banner != null) {
            bannerBytes = drawableToByteArray(banner);
        }

        if (icon != null) {
            iconBytes = drawableToByteArray(icon);
        }

        try {
            applicationVersionName = packageManager.getPackageInfo(activityInfo.packageName, 0).versionName;
        }
        catch (PackageManager.NameNotFoundException ignored) { }
        Map<String, Serializable> appMap = Map.of(
                "name", activityInfo.loadLabel(packageManager).toString(),
                "packageName", activityInfo.packageName,
                "banner", bannerBytes,
                "icon", iconBytes,
                "version", applicationVersionName,
                "sideloaded", sideloaded
        );

        return appMap;
    }

    private boolean launchApp(String packageName) {
        PackageManager packageManager = getPackageManager();
        Intent intent = packageManager.getLeanbackLaunchIntentForPackage(packageName);

        if (intent == null) {
            intent = packageManager.getLaunchIntentForPackage(packageName);
        }

        return tryStartActivity(intent);
    }

    private boolean openSettings() {
        return tryStartActivity(new Intent(Settings.ACTION_SETTINGS));
    }

    private boolean openAppInfo(String packageName) {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", packageName, null));

        return tryStartActivity(intent);
    }

    private boolean uninstallApp(String packageName) {
        Intent intent = new Intent(Intent.ACTION_DELETE)
                .setData(Uri.fromParts("package", packageName, null));

        return tryStartActivity(intent);
    }

    private boolean checkForGetContentAvailability() {
        List<ResolveInfo> intentActivities = getPackageManager().queryIntentActivities(
                new Intent(Intent.ACTION_GET_CONTENT, null).setTypeAndNormalize("image/*"),
                0);

        return !intentActivities.isEmpty();
    }

    private boolean isDefaultLauncher() {
        Intent intent = new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME);
        ResolveInfo defaultLauncher = getPackageManager().resolveActivity(intent, 0);

        if (defaultLauncher != null && defaultLauncher.activityInfo != null) {
            return defaultLauncher.activityInfo.packageName.equals(getPackageName());
        }

        return false;
    }

    private boolean startAmbientMode()
    {
        Intent intent = new Intent(Intent.ACTION_MAIN)
                .setClassName("com.android.systemui", "com.android.systemui.Somnambulator");

        return tryStartActivity(intent);
    }

    private Map<String, Object> getActiveNetworkInformation()
    {
        boolean hasNetworkAccess = false, hasInternetAccess = false;
        int wirelessNetworkSignalLevel = 0;
        long networkHandle = 0L;
        short networkType = -1;

        ConnectivityManager connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Network network = connectivityManager.getActiveNetwork();

            if (network != null) {
                NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
                // Align with NetworkType enum value indices, on file lib/providers/network_service.dart

                if (capabilities != null) {
                    // Bad naming: https://developer.android.com/develop/connectivity/network-ops/reading-network-state#introducing-net-capabilities
                    // See the bulleted list on the web page
                    hasNetworkAccess = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET);
                    hasInternetAccess = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED);

                    if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                        networkType = 0;
                        // TODO: Get signal level
                    }
                    else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                        networkType = 1;
                        wirelessNetworkSignalLevel = getWifiSignalLevel();
                    }
                    else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                        networkType = 2;
                    }
                    else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
                        networkType = 3;
                    }
                }
            }
            else {
                // TODO: If network is null, does it mean that the device is disconnected?
            }
        }
        else {
            // TODO: How to get an identifier for the current network in this case?
        }

        return Map.of(
                "handle", networkHandle,
                "hasNetworkAccess", hasNetworkAccess,
                "hasInternetAccess", hasInternetAccess,
                "networkType", networkType,
                "wirelessNetworkSignalLevel", wirelessNetworkSignalLevel);
    }

    private int getWifiSignalLevel()
    {
        WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(WIFI_SERVICE);
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

    private boolean tryStartActivity(Intent intent)
    {
        boolean success = true;

        try {
            startActivity(intent);
        }
        catch (Exception ignored) {
            success = false;
        }

        return success;
    }

    private byte[] drawableToByteArray(Drawable drawable) {
        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            return new byte[0];
        }

        Bitmap bitmap = drawableToBitmap(drawable);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return stream.toByteArray();
    }

    Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap = Bitmap.createBitmap(
                drawable.getIntrinsicWidth(),
                drawable.getIntrinsicHeight(),
                Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    private class LauncherAppsEventStreamHandler implements EventChannel.StreamHandler
    {
        private final LauncherApps      _launcherApps;
        private LauncherApps.Callback   _launcherAppsCallback;

        public LauncherAppsEventStreamHandler()
        {
            _launcherApps = (LauncherApps) getSystemService(LAUNCHER_APPS_SERVICE);
        }

        @Override
        public void onCancel(Object arguments)
        {
            _launcherApps.unregisterCallback(_launcherAppsCallback);
            _launcherAppsCallbacks.remove(_launcherAppsCallback);
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink events)
        {
            _launcherAppsCallback = new LauncherAppsCallback(events);

            _launcherAppsCallbacks.add(_launcherAppsCallback);
            _launcherApps.registerCallback(_launcherAppsCallback);
        }
    }

    private class NetworkEventStreamHandler implements EventChannel.StreamHandler
    {
        private final ConnectivityManager           _connectivityManager;
        private ConnectivityManager.NetworkCallback _networkCallback;

        public  NetworkEventStreamHandler()
        {
            _connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink events) {
            NetworkRequest request = new NetworkRequest.Builder()
                    .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                    .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR)
                    .addTransportType(NetworkCapabilities.TRANSPORT_ETHERNET)
                    .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                    .build();

            _networkCallback = new NetworkCallbackImpl(events);

            try {
                _connectivityManager.registerNetworkCallback(request, _networkCallback);
            }
            catch (RuntimeException ignored) { }
        }

        @Override
        public void onCancel(Object arguments) {
            _connectivityManager.unregisterNetworkCallback(_networkCallback);
        }
    }

    private class LauncherAppsCallback extends LauncherApps.Callback
    {
        EventChannel.EventSink _events;

        public LauncherAppsCallback(EventChannel.EventSink events)
        {
            _events = events;
        }

        @Override
        public void onPackageRemoved(String packageName, UserHandle user) {
            _events.success(Map.of(
                    "action", "PACKAGE_REMOVED",
                    "activityInfo", packageName));
        }

        @Override
        public void onPackageAdded(String packageName, UserHandle user) {
            Map<String, Serializable> application = getApplication(packageName);

            if (!application.isEmpty()) {
                _events.success(Map.of(
                        "action", "PACKAGE_ADDED",
                        "activityInfo", application));
            }
        }

        @Override
        public void onPackageChanged(String packageName, UserHandle user) {
            Map<String, Serializable> application = getApplication(packageName);

            if (!application.isEmpty()) {
                _events.success(Map.of(
                        "action", "PACKAGE_CHANGED",
                        "activityInfo", application));
            }
        }

        @Override
        public void onPackagesAvailable(String[] packageNames, UserHandle user, boolean replacing) {
            List<Map<String, Serializable>> applications = new ArrayList<>(packageNames.length);

            for (String name : packageNames) {
                Map<String, Serializable> application = getApplication(name);

                if (!application.isEmpty()) {
                    applications.add(application);
                }
            }

            if (!applications.isEmpty()) {
                _events.success(Map.of(
                        "action", "PACKAGES_AVAILABLE",
                        "activitiesInfo", applications));
            }
        }

        @Override
        public void onPackagesUnavailable(String[] packageNames, UserHandle user, boolean replacing) {
        }
    }

    private class NetworkCallbackImpl extends ConnectivityManager.NetworkCallback
    {
        private final EventChannel.EventSink _events;

        public NetworkCallbackImpl(EventChannel.EventSink events)
        {
            _events = events;
        }

        @Override
        public void onAvailable(@NonNull Network network) {
            // TODO: Something here is causing an exception about a method that can only be called on the UI Thread??
           // _events.success(Map.of(
           //         "name", "NETWORK_AVAILABLE",
           //         "arguments", network.toString()
           // ));
        }

        @Override
        public void onCapabilitiesChanged(@NonNull Network network, @NonNull NetworkCapabilities networkCapabilities) {
            _events.success(Map.of(
                    "name", "CAPABILITIES_CHANGED",
                    "arguments", networkCapabilities
            ));
        }
    }

}
