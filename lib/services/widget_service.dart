import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Android виджетіне ақпарат жіберуге арналған қызмет / Сервис для отправки информации на Android виджет
class WidgetService {
  static const MethodChannel _channel = MethodChannel('com.kazakhstanradio.app/widget');
  static const EventChannel _eventChannel = EventChannel('com.kazakhstanradio.app/widget_events');

  static Future<void> updateWidget({
    required String stationName,
    required bool isPlaying,
    String? currentTrack,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_station_name', stationName);
      await prefs.setBool('is_playing', isPlaying);
      if (currentTrack != null) {
        await prefs.setString('current_track', currentTrack);
      } else {
        await prefs.remove('current_track');
      }

      // Notify Android widget to update
      await _channel.invokeMethod('updateWidget');
    } catch (e) {
      print('Widget update error: $e');
    }
  }

  /// Виджет ойнату/кідірту әрекеті / Действие воспроизведения/паузы виджета
  static void listenToWidgetActions(void Function() onPlayPause) {
    _eventChannel.receiveBroadcastStream().listen((event) {
      if (event == 'TOGGLE_PLAY_PAUSE') {
        onPlayPause();
      }
    });
  }
}
