import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import 'audio_service.dart';
import '../models/radio_station.dart';

/// Дабыл қызметі / Сервис будильника
class AlarmService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _alarmKey = 'alarm_time';
  static const String _alarmStationKey = 'alarm_station_id';

  /// Инициализация / Инициализация
  static Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Almaty'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle alarm trigger / Обработка срабатывания будильника
        await _handleAlarmTrigger();
      },
    );
  }

  /// Дабыл орнату / Установить будильник
  static Future<void> setAlarm(DateTime time, String stationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_alarmKey, time.toIso8601String());
    await prefs.setString(_alarmStationKey, stationId);

    final scheduledTime = tz.TZDateTime.from(time, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Дабыл / Будильник',
      channelDescription: 'Дабыл хабарландырулары / Уведомления будильника',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.zonedSchedule(
      0,
      'Дабыл / Будильник',
      'Радионы қосу / Включить радио',
      scheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Дабылды өшіру / Отключить будильник
  static Future<void> cancelAlarm() async {
    await _notifications.cancel(0);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_alarmKey);
    await prefs.remove(_alarmStationKey);
  }

  /// Дабыл уақытын алу / Получить время будильника
  static Future<DateTime?> getAlarmTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_alarmKey);
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    return null;
  }

  /// Дабыл сәтінде ойнату / Воспроизвести при срабатывании будильника
  static Future<void> _handleAlarmTrigger() async {
    final stationId = await getAlarmStationId();
    if (stationId != null) {
      final station = kazakhstanRadioStations.firstWhere(
        (s) => s.id == stationId,
        orElse: () => kazakhstanRadioStations.first,
      );
      
      final audioNotifier = audioServiceProvider.notifier;
      await audioNotifier.playStation(station);
    }
  }

  /// Дабыл станциясын алу / Получить станцию будильника
  static Future<String?> getAlarmStationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_alarmStationKey);
  }

  /// Дабыл қойылған ма / Установлен ли будильник
  static Future<bool> isAlarmSet() async {
    final time = await getAlarmTime();
    return time != null;
  }
}
