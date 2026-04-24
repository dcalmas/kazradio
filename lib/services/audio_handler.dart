import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../models/radio_station.dart';

/// Radio Audio Handler / Обработчик радио аудио
/// Lock screen notification үшін / Для уведомления на экране блокировки
class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    // Плеер күйін тыңдау / Прослушивание состояния плеера
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final processingState = _player.processingState;

      if (processingState == ProcessingState.idle) {
        playbackState.add(PlaybackState(
          controls: [],
          processingState: AudioProcessingState.idle,
        ));
      } else if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playbackState.add(PlaybackState(
          controls: [MediaControl.pause],
          processingState: AudioProcessingState.loading,
          playing: playing,
        ));
      } else if (playing) {
        playbackState.add(PlaybackState(
          controls: [
            MediaControl.pause,
            MediaControl.stop,
            MediaControl.skipToNext,
            MediaControl.skipToPrevious,
          ],
          processingState: AudioProcessingState.ready,
          playing: true,
          updatePosition: _player.position,
        ));
      } else {
        playbackState.add(PlaybackState(
          controls: [
            MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
            MediaControl.skipToPrevious,
          ],
          processingState: AudioProcessingState.ready,
          playing: false,
          updatePosition: _player.position,
        ));
      }
    });

    // ICY metadata тыңдау / Прослушивание ICY metadata
    _player.icyMetadataStream.listen((metadata) {
      if (metadata != null && metadata.info != null) {
        final currentMediaItem = mediaItem.value;
        if (currentMediaItem != null) {
          final trackInfo = metadata.info!.title;
          if (trackInfo != null) {
            final updatedMediaItem = currentMediaItem.copyWith(
              title: trackInfo,
            );
            this.mediaItem.add(updatedMediaItem);
          }
        }
      }
    });
  }

  /// Станцияны ойнату / Воспроизведение станции
  Future<void> playStation(RadioStation station) async {
    final mediaItem = MediaItem(
      id: station.id,
      album: 'Kazakhstan Radio',
      title: station.name,
      artist: station.genre,
      artUri: station.logoUrl != null ? Uri.parse(station.logoUrl!) : null,
    );

    this.mediaItem.add(mediaItem);

    final audioSource = AudioSource.uri(
      Uri.parse(station.streamUrl),
      tag: mediaItem,
    );

    await _player.setAudioSource(audioSource);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {
    final currentIndex = kazakhstanRadioStations.indexWhere(
      (s) => s.id == mediaItem.value?.id,
    );
    if (currentIndex >= 0 && currentIndex < kazakhstanRadioStations.length - 1) {
      await playStation(kazakhstanRadioStations[currentIndex + 1]);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final currentIndex = kazakhstanRadioStations.indexWhere(
      (s) => s.id == mediaItem.value?.id,
    );
    if (currentIndex > 0) {
      await playStation(kazakhstanRadioStations[currentIndex - 1]);
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    switch (button) {
      case MediaButton.media:
        if (_player.playing) {
          pause();
        } else {
          play();
        }
        break;
      case MediaButton.next:
        skipToNext();
        break;
      case MediaButton.previous:
        skipToPrevious();
        break;
      default:
        break;
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < kazakhstanRadioStations.length) {
      await playStation(kazakhstanRadioStations[index]);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // Radio stations тізімі қолданылады / Используется список радиостанций
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // Radio stations тізімі қолданылады / Используется список радиостанций
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    // Radio stations тізімі қолданылады / Используется список радиостанций
  }

  @override
  Future<void> prepare() async {
    // Бос әрекет / Пустое действие
  }

  @override
  Future<void> prepareFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    final station = kazakhstanRadioStations.firstWhere(
      (s) => s.id == mediaId,
      orElse: () => kazakhstanRadioStations.first,
    );
    final mediaItem = MediaItem(
      id: station.id,
      album: 'Kazakhstan Radio',
      title: station.name,
      artist: station.genre,
      artUri: station.logoUrl != null ? Uri.parse(station.logoUrl!) : null,
    );
    this.mediaItem.add(mediaItem);
  }

  @override
  Future<void> prepareFromSearch(String query,
      [Map<String, dynamic>? extras]) async {
    // Search функционалсыз / Без поиска
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    final station = kazakhstanRadioStations.firstWhere(
      (s) => s.id == mediaId,
      orElse: () => kazakhstanRadioStations.first,
    );
    await playStation(station);
  }

  @override
  Future<void> playFromSearch(String query,
      [Map<String, dynamic>? extras]) async {
    // Search функционалсыз / Без поиска
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    // Бағдарламада repeat режимі жоқ / В приложении нет режима повтора
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    // Бағдарламада shuffle режимі жоқ / В приложении нет режима перемешивания
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    // Қосымша әрекеттер / Дополнительные действия
  }

  @override
  Future<void> fastForward() async {
    // Radio streaming үшін fast forward жоқ / Нет перемотки вперед для радио
  }

  @override
  Future<void> rewind() async {
    // Radio streaming үшін rewind жоқ / Нет перемотки назад для радио
  }

  @override
  Future<void> seekToNext() => skipToNext();

  @override
  Future<void> seekToPrevious() => skipToPrevious();

  @override
  Future<void> setCaptioningEnabled(bool enabled) async {
    // Subtitles жоқ / Нет субтитров
  }

  @override
  Future<void> setRating(Rating rating, [Map<String, dynamic>? extras]) async {
    // Rating жоқ / Нет рейтинга
  }

  @override
  Future<void> clickSearchButton() async {
    // Search функционалсыз / Без поиска
  }
}
