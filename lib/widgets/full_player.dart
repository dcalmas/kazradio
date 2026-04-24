import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/radio_station.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'station_tile.dart';

/// Full Player Widget / Полный плеер виджет
/// Толық плеер станция таңдау мүмкіндігімен / Полный плеер с возможностью выбора станции
class FullPlayer extends ConsumerWidget {
  const FullPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: audioState.currentStation != null
              ? audioState.currentStation!.gradientColors
              : [AppTheme.neonViolet, AppTheme.neonCyan],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header / Заголовок
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Қазақстан Радио',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Volume control / Управление громкостью
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_down, color: Colors.white, size: 20),
                        SizedBox(
                          width: 80,
                          child: Material(
                            color: Colors.transparent,
                            child: Slider(
                              value: audioState.volume,
                              onChanged: audioNotifier.setVolume,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        const Icon(Icons.volume_up, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: audioNotifier.toggleMute,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: audioState.isMuted
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              audioState.isMuted ? Icons.volume_off : Icons.volume_mute,
                              color: audioState.isMuted ? Colors.red : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Current station info / Информация о текущей станции
            if (audioState.currentStation != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      audioState.currentStation!.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Ағымдағы ән / Текущая песня
                    if (audioState.currentTrack != null)
                      Column(
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            audioState.currentTrack!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                        ],
                      )
                    else
                      Text(
                        audioState.currentStation!.genre,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      audioState.currentStation!.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Playback controls / Управление воспроизведением
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: audioNotifier.previousStation,
                          icon: const Icon(Icons.skip_previous),
                          color: Colors.white,
                          iconSize: 48,
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: audioNotifier.togglePlayPause,
                            icon: Icon(
                              audioState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            color: audioState.currentStation!.accentColor,
                            iconSize: 48,
                            padding: const EdgeInsets.all(20),
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: audioNotifier.nextStation,
                          icon: const Icon(Icons.skip_next),
                          color: Colors.white,
                          iconSize: 48,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Station list / Список станций
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: kazakhstanRadioStations.length,
                itemBuilder: (context, index) {
                  final station = kazakhstanRadioStations[index];
                  return StationTile(
                    station: station,
                    onTap: () => audioNotifier.playStation(station),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
