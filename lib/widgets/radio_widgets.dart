import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Радио виджеті - 1-вариант / Радио виджет - 1 вариант
/// Кіші қарапайым виджет / Малый простой виджет
class RadioWidgetSmall extends ConsumerWidget {
  const RadioWidgetSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);
    final station = audioState.currentStation;

    if (station == null) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: station.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    station.countryFlag,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      audioState.isPlaying ? 'Ойнатылуда' : 'Кідіртілген',
                      style: TextStyle(
                        color: audioState.isPlaying
                            ? station.accentColor
                            : AppTheme.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: audioNotifier.togglePlayPause,
                icon: Icon(
                  audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: station.accentColor,
                  size: 28,
                ),
              ),
            ],
          ),
          if (audioState.currentTrack != null) ...[
            const SizedBox(height: 8),
            Text(
              audioState.currentTrack!,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Радио виджеті - 2-вариант / Радио виджет - 2 вариант
/// Үлкен детальды виджет / Большой детальный виджет
class RadioWidgetLarge extends ConsumerWidget {
  const RadioWidgetLarge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);
    final station = audioState.currentStation;

    if (station == null) {
      return GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.radio_outlined,
                size: 48,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                'Станция таңдалмаған',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      hasGlow: true,
      glowColor: station.accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Станция атауы / Название станции
          Text(
            station.name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Жанр / Жанр
          Text(
            station.genre,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Ағымдағы ән / Текущая песня
          if (audioState.currentTrack != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: station.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: station.accentColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      audioState.currentTrack!,
                      style: TextStyle(
                        color: station.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Басқару / Управление
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Алдыңғы / Предыдущая
              IconButton(
                onPressed: audioNotifier.previousStation,
                icon: const Icon(Icons.skip_previous),
                color: AppTheme.textSecondary,
                iconSize: 32,
              ),
              // Play/Pause / Воспроизведение/Пауза
              Container(
                decoration: BoxDecoration(
                  color: station.accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: station.accentColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: audioNotifier.togglePlayPause,
                  icon: Icon(
                    audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 32,
                ),
              ),
              // Келесі / Следующая
              IconButton(
                onPressed: audioNotifier.nextStation,
                icon: const Icon(Icons.skip_next),
                color: AppTheme.textSecondary,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
