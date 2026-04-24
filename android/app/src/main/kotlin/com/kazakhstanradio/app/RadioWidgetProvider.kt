package com.kazakhstanradio.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class RadioWidgetProvider : AppWidgetProvider() {
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            ACTION_UPDATE_WIDGET -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(
                    ComponentName(context, RadioWidgetProvider::class.java)
                )
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
            ACTION_PLAY_PAUSE -> {
                // Send broadcast to Flutter to toggle play/pause
                val flutterIntent = Intent("com.kazakhstanradio.app.TOGGLE_PLAY_PAUSE")
                context.sendBroadcast(flutterIntent)
            }
        }
    }

    companion object {
        const val ACTION_UPDATE_WIDGET = "com.kazakhstanradio.app.UPDATE_WIDGET"
        const val ACTION_PLAY_PAUSE = "com.kazakhstanradio.app.PLAY_PAUSE"
        
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.radio_widget)
            
            // Get current station info from SharedPreferences
            val prefs = context.getSharedPreferences("RadioApp", Context.MODE_PRIVATE)
            val stationName = prefs.getString("current_station_name", "Станция таңдалмаған") ?: "Станция таңдалмаған"
            val isPlaying = prefs.getBoolean("is_playing", false)
            val currentTrack = prefs.getString("current_track", null)
            
            // Update views
            views.setTextViewText(R.id.widget_station_name, stationName)
            views.setTextViewText(R.id.widget_status, if (isPlaying) "Ойнатылуда" else "Кідіртілген")
            
            if (currentTrack != null && currentTrack.isNotEmpty()) {
                views.setTextViewText(R.id.widget_current_track, currentTrack)
                views.setViewVisibility(R.id.widget_current_track, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_current_track, android.view.View.GONE)
            }
            
            // Update play/pause icon
            val iconRes = if (isPlaying) {
                android.R.drawable.ic_media_pause
            } else {
                android.R.drawable.ic_media_play
            }
            views.setImageViewResource(R.id.widget_play_pause, iconRes)
            
            // Create play/pause intent
            val playPauseIntent = Intent(context, RadioWidgetProvider::class.java).apply {
                action = ACTION_PLAY_PAUSE
            }
            val playPausePendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                playPauseIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_play_pause, playPausePendingIntent)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
