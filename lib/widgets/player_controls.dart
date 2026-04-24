import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Плеер басқару элементтері / Элементы управления плеером
class PlayerControls extends ConsumerWidget {
  final bool showVolume;
  final bool showSleepTimer;
  final double iconSize;

  const PlayerControls({
    super.key,
    this.showVolume = true,
    this.showSleepTimer = true,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Негізгі басқару түймелері / Основные кнопки управления
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Алдыңғы станция / Предыдущая станция
            _ControlButton(
              icon: Icons.skip_previous_rounded,
              onTap: audioNotifier.previousStation,
              size: iconSize * 1.2,
            ),
            
            const SizedBox(width: 20),
            
            // Ойнату/Кідірту түймесі / Кнопка воспроизведения/паузы
            _PlayPauseButton(
              isPlaying: audioState.isPlaying,
              isLoading: audioState.isLoading,
              onTap: audioNotifier.togglePlayPause,
              size: iconSize * 2,
            ),
            
            const SizedBox(width: 20),
            
            // Келесі станция / Следующая станция
            _ControlButton(
              icon: Icons.skip_next_rounded,
              onTap: audioNotifier.nextStation,
              size: iconSize * 1.2,
            ),
          ],
        ),

        if (showVolume) ...[
          const SizedBox(height: 24),
          // Дыбыс деңгейі слайдері / Слайдер громкости
          _VolumeSlider(
            volume: audioState.volume,
            onChanged: audioNotifier.setVolume,
          ),
        ],

        if (showSleepTimer) ...[
          const SizedBox(height: 16),
          // Ұйқы таймері / Таймер сна
          _SleepTimerControls(
            sleepTimer: audioState.sleepTimer,
            remainingTime: audioState.remainingTime,
            onSetTimer: audioNotifier.setSleepTimer,
            onCancelTimer: audioNotifier.cancelSleepTimer,
          ),
        ],
      ],
    );
  }
}

/// Ойнату/Кідірту түймесі / Кнопка воспроизведения/паузы
class _PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;
  final double size;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
    required this.size,
  });

  @override
  State<_PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<_PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppTheme.animationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    _scaleController.forward().then((_) => _scaleController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.neonGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonViolet.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppTheme.neonCyan.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : Icon(
                      widget.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: widget.size * 0.5,
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// Басқару түймесі / Кнопка управления
class _ControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed
              ? AppTheme.glassDeep
              : AppTheme.glassWhite.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(3, 3),
                  ),
                  BoxShadow(
                    color: AppTheme.glassWhite.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(-3, -3),
                  ),
                ],
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}

/// Дыбыс деңгейі слайдері / Слайдер громкости
class _VolumeSlider extends StatelessWidget {
  final double volume;
  final Function(double) onChanged;

  const _VolumeSlider({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            volume == 0
                ? Icons.volume_off_rounded
                : volume < 0.3
                    ? Icons.volume_mute_rounded
                    : volume < 0.7
                        ? Icons.volume_down_rounded
                        : Icons.volume_up_rounded,
            color: AppTheme.textSecondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                    pressedElevation: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  activeTrackColor: AppTheme.neonViolet,
                  inactiveTrackColor: AppTheme.glassWhite.withOpacity(0.3),
                  thumbColor: AppTheme.neonCyan,
                  overlayColor: AppTheme.glowCyan,
                ),
                child: Slider(
                  value: volume,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(volume * 100).toInt()}%',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ұйқы таймері басқаруы / Управление таймером сна
class _SleepTimerControls extends StatelessWidget {
  final Duration? sleepTimer;
  final Duration? remainingTime;
  final Function(Duration) onSetTimer;
  final VoidCallback onCancelTimer;

  const _SleepTimerControls({
    this.sleepTimer,
    this.remainingTime,
    required this.onSetTimer,
    required this.onCancelTimer,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}с ${minutes}м';
    }
    return '${minutes}м';
  }

  void _showTimerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SleepTimerPicker(
        onSelect: (duration) {
          Navigator.pop(context);
          onSetTimer(duration);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = sleepTimer != null;

    return GestureDetector(
      onTap: () => _showTimerPicker(context),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hasGlow: isActive,
        glowColor: AppTheme.neonCyan,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.timer_rounded : Icons.timer_off_rounded,
              color: isActive ? AppTheme.neonCyan : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isActive && remainingTime != null
                  ? 'Қалды: ${_formatDuration(remainingTime!)} / Осталось: ${_formatDuration(remainingTime!)}'
                  : 'Ұйқы таймері / Таймер сна',
              style: TextStyle(
                color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onCancelTimer,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.glassWhite.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ұйқы таймерін таңдау / Выбор таймера сна
class _SleepTimerPicker extends StatelessWidget {
  final Function(Duration) onSelect;

  _SleepTimerPicker({required this.onSelect});

  final List<Duration> _timerOptions = [
    const Duration(minutes: 5),
    const Duration(minutes: 10),
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(minutes: 45),
    const Duration(hours: 1),
    const Duration(hours: 2),
  ];

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '$hours сағат $minutes мин / $hours час $minutes мин';
    } else if (hours > 0) {
      return '$hours сағат / $hours час';
    }
    return '$minutes минут / $minutes мин';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.deepGlassDecoration(borderRadius: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Ұйқы таймерін таңдаңыз\nВыберите таймер сна',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(color: AppTheme.borderSubtle, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timerOptions.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppTheme.borderSubtle,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final duration = _timerOptions[index];
              return ListTile(
                onTap: () => onSelect(duration),
                title: Text(
                  _formatDuration(duration),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                trailing: const Icon(
                  Icons.timer_rounded,
                  color: AppTheme.neonCyan,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
