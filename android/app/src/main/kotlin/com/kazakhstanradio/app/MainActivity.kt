package com.kazakhstanradio.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import androidx.annotation.NonNull
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity() {
    private val METHOD_CHANNEL = "com.kazakhstanradio.app/widget"
    private val EVENT_CHANNEL = "com.kazakhstanradio.app/widget_events"
    private var eventSink: EventChannel.EventSink? = null
    private var widgetEventReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method channel for widget updates
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                val intent = Intent(this, RadioWidgetProvider::class.java).apply {
                    action = RadioWidgetProvider.ACTION_UPDATE_WIDGET
                }
                sendBroadcast(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        // Event channel for widget actions
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    registerWidgetReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    unregisterWidgetReceiver()
                }
            }
        )
    }

    private fun registerWidgetReceiver() {
        widgetEventReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "com.kazakhstanradio.app.TOGGLE_PLAY_PAUSE") {
                    eventSink?.success("TOGGLE_PLAY_PAUSE")
                }
            }
        }
        val filter = IntentFilter("com.kazakhstanradio.app.TOGGLE_PLAY_PAUSE")
        registerReceiver(widgetEventReceiver, filter)
    }

    private fun unregisterWidgetReceiver() {
        widgetEventReceiver?.let {
            unregisterReceiver(it)
        }
        widgetEventReceiver = null
    }

    override fun onDestroy() {
        unregisterWidgetReceiver()
        super.onDestroy()
    }
}
