package me.efesser.flauncher;

import android.telephony.TelephonyCallback;

import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class TelephonyCallbackImpl extends TelephonyCallback
        implements TelephonyCallback.DataConnectionStateListener
{
    private final EventChannel.EventSink _eventSink;

    public TelephonyCallbackImpl(EventChannel.EventSink eventSink)
    {
        _eventSink = eventSink;
    }

    @Override
    public void onDataConnectionStateChanged(int state, int networkType)
    {
        _eventSink.success(Map.of(
                "name", "CELLULAR_STATE_CHANGED",
                "arguments", networkType
        ));
    }
}
