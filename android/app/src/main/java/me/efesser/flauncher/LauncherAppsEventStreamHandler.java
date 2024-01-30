package me.efesser.flauncher;

import android.content.pm.LauncherApps;
import android.os.UserHandle;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class LauncherAppsEventStreamHandler implements EventChannel.StreamHandler
{
    private final LauncherApps _launcherApps;
    private final MainActivity _activity;

    private LauncherApps.Callback _launcherAppsCallback;

    public LauncherAppsEventStreamHandler(MainActivity activity, LauncherApps launcherApps)
    {
        _activity = activity;
        _launcherApps = launcherApps;
    }

    @Override
    public void onCancel(Object arguments)
    {
        _launcherApps.unregisterCallback(_launcherAppsCallback);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events)
    {
        _launcherAppsCallback = new LauncherAppsCallback(events);
        _launcherApps.registerCallback(_launcherAppsCallback);
    }


    private class LauncherAppsCallback extends LauncherApps.Callback
    {
        private final EventChannel.EventSink _eventSink;

        public LauncherAppsCallback(EventChannel.EventSink eventSink)
        {
            _eventSink = eventSink;
        }

        @Override
        public void onPackageRemoved(String packageName, UserHandle user) {
            _eventSink.success(Map.of(
                    "action", "PACKAGE_REMOVED",
                    "activityInfo", packageName));
        }

        @Override
        public void onPackageAdded(String packageName, UserHandle user) {
            Map<String, Serializable> application = _activity.getApplication(packageName);

            if (!application.isEmpty()) {
                _eventSink.success(Map.of(
                        "action", "PACKAGE_ADDED",
                        "activityInfo", application));
            }
        }

        @Override
        public void onPackageChanged(String packageName, UserHandle user) {
            Map<String, Serializable> application = _activity.getApplication(packageName);

            if (!application.isEmpty()) {
                _eventSink.success(Map.of(
                        "action", "PACKAGE_CHANGED",
                        "activityInfo", application));
            }
        }

        @Override
        public void onPackagesAvailable(String[] packageNames, UserHandle user, boolean replacing) {
            List<Map<String, Serializable>> applications = new ArrayList<>(packageNames.length);

            for (String name : packageNames) {
                Map<String, Serializable> application = _activity.getApplication(name);

                if (!application.isEmpty()) {
                    applications.add(application);
                }
            }

            if (!applications.isEmpty()) {
                _eventSink.success(Map.of(
                        "action", "PACKAGES_AVAILABLE",
                        "activitiesInfo", applications));
            }
        }

        @Override
        public void onPackagesUnavailable(String[] packageNames, UserHandle user, boolean replacing) {
        }
    }
}
