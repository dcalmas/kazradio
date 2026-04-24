import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';

/// Mini Player Widget / Мини плеер виджет
/// Басты экрандағы қысқа плеер / Короткий плеер на главном экране
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);

    if (audioState.currentStation == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: audioState.currentStation!.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: audioState.currentStation!.accentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Станция атауы / Название станции
          Text(
            audioState.currentStation!.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Ағымдағы ән / Текущая песня
          if (audioState.currentTrack != null)
            Text(
              audioState.currentTrack!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            // Жанр / Жанр
            Text(
              audioState.currentStation!.genre,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 16),
          // Басқару батырмалары / Кнопки управления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Алдыңғы станция / Предыдущая станция
              IconButton(
                onPressed: audioNotifier.previousStation,
                icon: const Icon(Icons.skip_previous),
                color: Colors.white,
                iconSize: 32,
              ),
              // Play/Pause / Воспроизведение/Пауза
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: audioNotifier.togglePlayPause,
                  icon: Icon(
                    audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  color: audioState.currentStation!.accentColor,
                  iconSize: 32,
                ),
              ),
              // Келесі станция / Следующая станция
              IconButton(
                onPressed: audioNotifier.nextStation,
                icon: const Icon(Icons.skip_next),
                color: Colors.white,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
