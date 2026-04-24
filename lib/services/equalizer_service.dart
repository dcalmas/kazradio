import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Эквалайзер қызметі / Сервис эквалайзера
class EqualizerService {
  static const String _bassKey = 'eq_bass';
  static const String _trebleKey = 'eq_treble';
  static const String _midKey = 'eq_mid';

  double _bass = 0.0;
  double _treble = 0.0;
  double _mid = 0.0;

  /// Басс мәні / Значение баса
  double get bass => _bass;

  /// Требл мәні / Значение требла
  double get treble => _treble;

  /// Орта мәні / Среднее значение
  double get mid => _mid;

  /// Эквалайзер параметрлерін жүктеу / Загрузить параметры эквалайзера
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _bass = prefs.getDouble(_bassKey) ?? 0.0;
    _treble = prefs.getDouble(_trebleKey) ?? 0.0;
    _mid = prefs.getDouble(_midKey) ?? 0.0;
  }

  /// Басс орнату / Установить бас
  Future<void> setBass(double value) async {
    _bass = value.clamp(-10.0, 10.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_bassKey, _bass);
  }

  /// Требл орнату / Установить требл
  Future<void> setTreble(double value) async {
    _treble = value.clamp(-10.0, 10.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_trebleKey, _treble);
  }

  /// Орта орнату / Установить середину
  Future<void> setMid(double value) async {
    _mid = value.clamp(-10.0, 10.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_midKey, _mid);
  }

  /// Эквалайзерді қалпына келтіру / Сбросить эквалайзер
  Future<void> reset() async {
    _bass = 0.0;
    _treble = 0.0;
    _mid = 0.0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bassKey);
    await prefs.remove(_trebleKey);
    await prefs.remove(_midKey);
  }

  /// Эквалайзерді аудио сессиясына қолдану / Применить эквалайзер к аудио сессии
  Future<void> applyToAudioSession(AudioSession session) async {
    // Note: just_audio doesn't have built-in equalizer support
    // This would require platform-specific implementation
    // For now, we'll just store the settings
    // Future enhancement: Use native Android Equalizer or iOS AVAudioSessionEQ
  }
}
