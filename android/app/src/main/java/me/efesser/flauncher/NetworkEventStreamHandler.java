package me.efesser.flauncher;

import android.content.Context;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class NetworkEventStreamHandler implements EventChannel.StreamHandler
{
    private final ConnectivityManager _connectivityManager;
    private final Context _context;
    private final Handler _handler;

    private ConnectivityManager.NetworkCallback _networkCallback;
    private NetworkChangeReceiver _networkChangeReceiver;

    public NetworkEventStreamHandler(Context context, ConnectivityManager connectivityManager)
    {
        _connectivityManager = connectivityManager;
        _context = context;
        _handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                _networkCallback = new NetworkCallbackImpl(events, null);
                _connectivityManager.registerDefaultNetworkCallback(_networkCallback, _handler);
            }
            else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                _networkCallback = new NetworkCallbackImpl(events, _handler);
                _connectivityManager.registerDefaultNetworkCallback(_networkCallback);
            }
            else {
                _networkChangeReceiver = new NetworkChangeReceiver(events);
                IntentFilter filter = new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION);
                _context.registerReceiver(_networkChangeReceiver, filter);
            }
        }
        catch (RuntimeException ignored) { }
    }

    @Override
    public void onCancel(Object arguments) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            _connectivityManager.unregisterNetworkCallback(_networkCallback);
        }
        else {
            _context.unregisterReceiver(_networkChangeReceiver);
        }
    }

    private static class NetworkCallbackImpl extends ConnectivityManager.NetworkCallback
    {
        private final EventChannel.EventSink    _eventSink;
        private final Handler                   _handler;

        public NetworkCallbackImpl(EventChannel.EventSink eventSink, Handler handler)
        {
            _eventSink = eventSink;
            _handler = handler;
        }

        private void postEvent(Map<String, Object> map)
        {
            if (_handler != null) {
                _handler.post(() -> _eventSink.success(map));
            }
            else {
                _eventSink.success(map);
            }
        }

        @Override
        public void onAvailable(@NonNull Network network) {
            // postEvent(Map.of(
            //         "name", "NETWORK_AVAILABLE",
            //         "arguments", network.toString()
            // ));
        }

        @Override
        public void onCapabilitiesChanged(@NonNull Network network, @NonNull NetworkCapabilities networkCapabilities) {
            Map<String, Object> map = NetworkUtils.getNetworkCapabilitiesInformation(networkCapabilities);
            postEvent(Map.of(
                    "name", "CAPABILITIES_CHANGED",
                    "arguments", map
            ));
        }
    }
}


