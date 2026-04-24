import 'package:shared_preferences/shared_preferences.dart';

/// Сапасы қызметі / Сервис качества
class QualityService {
  static const String _lowTrafficModeKey = 'low_traffic_mode';
  static const String _qualityKey = 'audio_quality';

  bool _lowTrafficMode = false;
  AudioQuality _quality = AudioQuality.high;

  /// Төмен трафик режимі / Режим низкого трафика
  bool get lowTrafficMode => _lowTrafficMode;

  /// Аудио сапасы / Качество аудио
  AudioQuality get quality => _quality;

  /// Параметрлерді жүктеу / Загрузить параметры
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _lowTrafficMode = prefs.getBool(_lowTrafficModeKey) ?? false;
    final qualityStr = prefs.getString(_qualityKey) ?? 'high';
    _quality = AudioQuality.values.firstWhere(
      (q) => q.name == qualityStr,
      orElse: () => AudioQuality.high,
    );
  }

  /// Төмен трафик режимін қосу/өшіру / Включить/выключить режим низкого трафика
  Future<void> toggleLowTrafficMode() async {
    _lowTrafficMode = !_lowTrafficMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lowTrafficModeKey, _lowTrafficMode);
    
    // Auto-adjust quality when low traffic mode is enabled
    if (_lowTrafficMode) {
      await setQuality(AudioQuality.low);
    } else {
      await setQuality(AudioQuality.high);
    }
  }

  /// Аудио сапасын орнату / Установить качество аудио
  Future<void> setQuality(AudioQuality quality) async {
    _quality = quality;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_qualityKey, quality.name);
  }

  /// Stream URL-ді сапасына қарай алу / Получить URL потока в зависимости от качества
  String getStreamUrl(String originalUrl) {
    if (_lowTrafficMode || _quality == AudioQuality.low) {
      // Return low bitrate version if available
      // For now, return original URL as streams may not have quality variants
      return originalUrl;
    }
    return originalUrl;
  }
}

/// Аудио сапасы / Качество аудио
enum AudioQuality {
  low('low'),
  medium('medium'),
  high('high');

  final String name;
  const AudioQuality(this.name);
}
