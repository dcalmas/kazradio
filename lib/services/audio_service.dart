import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/radio_station.dart';
import '../theme/app_theme.dart';
import '../services/widget_service.dart';
import '../services/audio_handler.dart';
import 'package:audio_service/audio_service.dart';

/// Аудио қызметі провайдері / Провайдер аудио сервиса
final audioServiceProvider = StateNotifierProvider<AudioServiceNotifier, AudioServiceState>(
  (ref) => AudioServiceNotifier(),
);

/// Аудио қызметінің күйі / Состояние аудио сервиса
@immutable
class AudioServiceState {
  /// Ағымдағы станция / Текущая станция
  final RadioStation? currentStation;
  
  /// Ойнату күйі / Состояние воспроизведения
  final PlaybackState playbackState;
  
  /// Жүктеу күйі / Состояние загрузки
  final bool isLoading;
  
  /// Қате туралы ақпарат / Информация об ошибке
  final String? error;
  
  /// Дыбыс деңгейі / Уровень громкости
  final double volume;
  
  /// Дыбыссыз / Без звука
  final bool isMuted;
  
  /// Ұйқы таймері / Таймер сна
  final Duration? sleepTimer;
  
  /// Қалған уақыт / Оставшееся время
  final Duration? remainingTime;
  
  /// Аудио деңгейі деректері / Данные уровней аудио
  final List<double> audioLevels;
  
  /// Ағымдағы ән атауы / Название текущей песни
  final String? currentTrack;

  const AudioServiceState({
    this.currentStation,
    this.playbackState = PlaybackState.idle,
    this.isLoading = false,
    this.error,
    this.volume = 1.0,
    this.isMuted = false,
    this.sleepTimer,
    this.remainingTime,
    this.audioLevels = const [],
    this.currentTrack,
  });

  AudioServiceState copyWith({
    RadioStation? currentStation,
    PlaybackState? playbackState,
    bool? isLoading,
    String? error,
    double? volume,
    bool? isMuted,
    Duration? sleepTimer,
    Duration? remainingTime,
    List<double>? audioLevels,
    String? currentTrack,
  }) {
    return AudioServiceState(
      currentStation: currentStation ?? this.currentStation,
      playbackState: playbackState ?? this.playbackState,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      sleepTimer: sleepTimer ?? this.sleepTimer,
      remainingTime: remainingTime ?? this.remainingTime,
      audioLevels: audioLevels ?? this.audioLevels,
      currentTrack: currentTrack ?? this.currentTrack,
    );
  }

  bool get isPlaying => playbackState == PlaybackState.playing;
  bool get isPaused => playbackState == PlaybackState.paused;
  bool get isBuffering => playbackState == PlaybackState.buffering;
  bool get hasError => error != null;
}

/// Ойнату күйлері / Состояния воспроизведения
enum PlaybackState {
  idle,      // Бос / Ожидание
  loading,   // Жүктеу / Загрузка
  buffering, // Буферлеу / Буферизация
  playing,   // Ойнату / Воспроизведение
  paused,    // Кідірту / Пауза
  error,     // Қате / Ошибка
}

/// Аудио қызметі нотифиері / Нотификатор аудио сервиса
class AudioServiceNotifier extends StateNotifier<AudioServiceState> {
  /// Audio Handler / Обработчик аудио
  RadioAudioHandler? _audioHandler;
  
  /// Ұйқы таймері таймері / Таймер таймера сна
  Timer? _sleepTimer;
  
  /// Аудио деңгейлерін симуляциялау таймері / Таймер симуляции уровней аудио
  Timer? _audioLevelTimer;
  
  /// Рандом генераторы / Генератор случайных чисел
  final Random _random = Random();

  /// Аудио сессиясы / Аудио сессия
  AudioSession? _audioSession;

  AudioServiceNotifier() : super(const AudioServiceState()) {
    _initAudioHandler();
    _initAudioSession();
    _startAudioLevelSimulation();
    _loadLastStation();
    _initWidgetListener();
  }

  /// Соңғы ойнатылған станцияны жүктеу / Загрузка последней воспроизведенной станции
  Future<void> _loadLastStation() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStationId = prefs.getString('last_station_id');
    if (lastStationId != null) {
      final station = kazakhstanRadioStations.firstWhere(
        (s) => s.id == lastStationId,
        orElse: () => kazakhstanRadioStations.first,
      );
      state = state.copyWith(currentStation: station);
      await WidgetService.updateWidget(
        stationName: station.name,
        isPlaying: false,
        currentTrack: null,
      );
    }
  }

  /// Виджет әрекеттерін тыңдау / Слушать действия виджета
  void _initWidgetListener() {
    WidgetService.listenToWidgetActions(() {
      if (state.isPlaying) {
        pause();
      } else {
        play();
      }
    });
  }

  /// Audio Handler инициализациялау / Инициализация Audio Handler
  Future<void> _initAudioHandler() async {
    _audioHandler = await AudioService.init(
      builder: () => RadioAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.kazakhstanradio.app.audio',
        androidNotificationChannelName: 'Kazakhstan Radio',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidShowNotificationBadge: true,
        androidNotificationIcon: 'drawable/ic_launcher_foreground',
      ),
    );
    
    _audioHandler!.playbackState.listen((playbackState) {
      if (playbackState.playing) {
        state = state.copyWith(playbackState: PlaybackState.playing);
      } else {
        state = state.copyWith(playbackState: PlaybackState.paused);
      }
      
      // Update Android widget / Обновить Android виджет
      if (state.currentStation != null) {
        WidgetService.updateWidget(
          stationName: state.currentStation!.name,
          isPlaying: state.isPlaying,
          currentTrack: state.currentTrack,
        );
      }
    });
    
    _audioHandler!.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        final station = kazakhstanRadioStations.firstWhere(
          (s) => s.id == mediaItem.id,
          orElse: () => kazakhstanRadioStations.first,
        );
        
        // Track name from ICY metadata / Название трека из ICY metadata
        String? currentTrack;
        if (mediaItem.title != station.name) {
          currentTrack = mediaItem.title;
        }
        
        state = state.copyWith(
          currentStation: station,
          currentTrack: currentTrack,
        );
        
        // Update Android widget / Обновить Android виджет
        WidgetService.updateWidget(
          stationName: station.name,
          isPlaying: state.isPlaying,
          currentTrack: currentTrack,
        );
      }
    });
  }

  /// Аудио сессиясын инициализациялау / Инициализация аудио сессии
  Future<void> _initAudioSession() async {
    _audioSession = await AudioSession.instance;
    await _audioSession!.configure(const AudioSessionConfiguration.music());
    
    _audioSession!.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (event.type == AudioInterruptionType.duck) {
          _audioHandler?.setVolume(0.3);
        } else {
          pause();
        }
      } else {
        if (event.type == AudioInterruptionType.duck) {
          _audioHandler?.setVolume(state.volume);
        } else {
          play();
        }
      }
    });
  }

  /// Аудио деңгейлерін симуляциялау / Симуляция уровней аудио
  void _startAudioLevelSimulation() {
    _audioLevelTimer?.cancel();
    _audioLevelTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (state.isPlaying) {
        // FFT стильді аудио деңгейлерін генерациялау
        // Генерация уровней аудио в стиле FFT
        final levels = List.generate(
          32,
          (index) {
            double baseAmplitude;
            if (index < 4) {
              baseAmplitude = 0.7 + _random.nextDouble() * 0.3; // Төмен жиіліктер / Низкие частоты
            } else if (index < 12) {
              baseAmplitude = 0.5 + _random.nextDouble() * 0.4; // Орта жиіліктер / Средние частоты
            } else {
              baseAmplitude = 0.3 + _random.nextDouble() * 0.3; // Жоғары жиіліктер / Высокие частоты
            }
            
            // Синус толқыны эффектісі / Эффект синусоидальной волны
            final time = DateTime.now().millisecondsSinceEpoch / 200;
            final wave = sin(time + index * 0.3) * 0.2;
            
            return (baseAmplitude + wave).clamp(0.05, 1.0);
          },
        );
        
        state = state.copyWith(audioLevels: levels);
      } else {
        // Бос күйде аз деңгейлер / Низкие уровни в idle состоянии
        final levels = List.generate(32, (_) => 0.05 + _random.nextDouble() * 0.05);
        state = state.copyWith(audioLevels: levels);
      }
    });
  }

  /// Станцияны ойнату / Воспроизведение станции
  Future<void> playStation(RadioStation station) async {
    try {
      // Save last played station / Сохранить последнюю воспроизведенную станцию
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_station_id', station.id);

      state = state.copyWith(
        currentStation: station,
        playbackState: PlaybackState.loading,
        isLoading: true,
        error: null,
      );

      await _audioHandler?.playStation(station);
      await _audioHandler?.setVolume(state.volume);

    } catch (e) {
      state = state.copyWith(
        error: 'Станцияны жүктеу қатесі / Ошибка загрузки станции: $e',
        playbackState: PlaybackState.error,
        isLoading: false,
      );
    }
  }

  /// Ойнатуды жалғастыру / Продолжить воспроизведение
  Future<void> play() async {
    await _audioHandler?.play();
  }

  /// Кідірту / Пауза
  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  /// Ойнатуды ауыстыру / Переключить воспроизведение
  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Дыбыс деңгейін орнату / Установить громкость
  Future<void> setVolume(double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    await _audioHandler?.setVolume(clampedVolume);
    state = state.copyWith(volume: clampedVolume, isMuted: false);
  }

  /// Дыбысты өшіру/қосу / Выключить/включить звук
  Future<void> toggleMute() async {
    if (state.isMuted) {
      await _audioHandler?.setVolume(state.volume);
      state = state.copyWith(isMuted: false);
    } else {
      await _audioHandler?.setVolume(0.0);
      state = state.copyWith(isMuted: true);
    }
  }

  /// Ұйқы таймерін орнату / Установить таймер сна
  void setSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    
    final endTime = DateTime.now().add(duration);
    
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = endTime.difference(DateTime.now());
      
      if (remaining.isNegative || remaining.inSeconds <= 0) {
        _sleepTimer?.cancel();
        pause();
        state = state.copyWith(
          sleepTimer: null,
          remainingTime: null,
        );
      } else {
        state = state.copyWith(remainingTime: remaining);
      }
    });

    state = state.copyWith(sleepTimer: duration);
  }

  /// Ұйқы таймерін тоқтату / Отменить таймер сна
  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    state = state.copyWith(
      sleepTimer: null,
      remainingTime: null,
    );
  }

  /// Келесі станцияға өту / Перейти к следующей станции
  Future<void> nextStation() async {
    final currentIndex = kazakhstanRadioStations.indexWhere(
      (s) => s.id == state.currentStation?.id,
    );
    
    if (currentIndex >= 0 && currentIndex < kazakhstanRadioStations.length - 1) {
      await playStation(kazakhstanRadioStations[currentIndex + 1]);
    } else if (kazakhstanRadioStations.isNotEmpty) {
      await playStation(kazakhstanRadioStations.first);
    }
  }

  /// Алдыңғы станцияға өту / Перейти к предыдущей станции
  Future<void> previousStation() async {
    final currentIndex = kazakhstanRadioStations.indexWhere(
      (s) => s.id == state.currentStation?.id,
    );
    
    if (currentIndex > 0) {
      await playStation(kazakhstanRadioStations[currentIndex - 1]);
    } else if (kazakhstanRadioStations.isNotEmpty) {
      await playStation(kazakhstanRadioStations.last);
    }
  }

  /// Қатені тазалау / Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _audioLevelTimer?.cancel();
    _audioHandler?.stop();
    super.dispose();
  }
}
