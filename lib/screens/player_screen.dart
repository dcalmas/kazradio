import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/radio_station.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/player_controls.dart';
import '../widgets/animated_visualizer.dart';

/// Толық плеер экраны / Экран полного плеера
/// 
/// Glassmorphism дизайн 2026 / Дизайн Glassmorphism 2026
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _vinylController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Винил айналу анимациясы / Анимация вращения винила
    _vinylController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Пульсация анимациясы / Анимация пульсации
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Толқын анимациясы / Анимация волны
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Аудио күйін тыңдау / Слушать состояние аудио
    final audioState = ref.read(audioServiceProvider);
    if (audioState.isPlaying) {
      _vinylController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final audioState = ref.read(audioServiceProvider);
    if (audioState.isPlaying) {
      _vinylController.repeat();
    } else {
      _vinylController.stop();
    }
  }

  @override
  void dispose() {
    _vinylController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioServiceProvider);
    final station = audioState.currentStation;

    if (station == null) {
      return _buildEmptyPlayer();
    }

    // Ойнату күйін жаңарту / Обновить состояние воспроизведения
    if (audioState.isPlaying && !_vinylController.isAnimating) {
      _vinylController.repeat();
    } else if (!audioState.isPlaying && _vinylController.isAnimating) {
      _vinylController.stop();
    }

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.bgDark,
              station.gradientColors.first.withOpacity(0.3),
              AppTheme.bgMid,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Жоғарғы панель / Верхняя панель
              _buildTopBar(station),

              // Контент / Контент
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Винил диск / Виниловый диск
                      _buildVinylDisc(station, audioState),

                      const SizedBox(height: 40),

                      // Станция ақпараты / Информация о станции
                      _buildStationInfo(station),

                      const SizedBox(height: 30),

                      // Аудио визуализатор / Аудио визуализатор
                      AnimatedAudioVisualizer(
                        audioLevels: audioState.audioLevels,
                        colors: [
                          station.accentColor,
                          AppTheme.neonCyan,
                        ],
                        barCount: 32,
                        maxHeight: 80,
                      ),

                      const SizedBox(height: 30),

                      // Басқару элементтері / Элементы управления
                      PlayerControls(
                        showVolume: true,
                        showSleepTimer: true,
                        iconSize: 32,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Бос плеерді құру / Построить пустой плеер
  Widget _buildEmptyPlayer() {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.radio_outlined,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Станция таңдалмаған\nСтанция не выбрана',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [AppTheme.neonViolet, AppTheme.neonCyan],
                        ),
                      ),
                      child: const Text(
                        'Артқа / Назад',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Жоғарғы панельді құру / Построить верхнюю панель
  Widget _buildTopBar(RadioStation station) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Артқа түймесі / Кнопка назад
          GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary,
              size: 28,
            ),
          ),

          // Тақырып / Заголовок
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Қазір ойнатылып жатыр / Сейчас играет',
                style: TextStyle(
                  color: station.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Қосымша опциялар / Дополнительные опции
          GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            onTap: () {
              _showStationOptions(station);
            },
            child: const Icon(
              Icons.more_vert_rounded,
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Винил дискті құру / Построить виниловый диск
  Widget _buildVinylDisc(RadioStation station, AudioServiceState audioState) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  station.accentColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
              boxShadow: audioState.isPlaying
                  ? [
                      BoxShadow(
                        color: station.accentColor.withOpacity(0.5),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ]
                  : null,
            ),
            child: AnimatedBuilder(
              animation: _vinylController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _vinylController.value * 2 * pi,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Сыртқы диск / Внешний диск
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.bgDark,
                              station.gradientColors.first.withOpacity(0.5),
                              AppTheme.bgMid,
                            ],
                          ),
                          border: Border.all(
                            color: station.accentColor.withOpacity(0.5),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(10, 10),
                            ),
                          ],
                        ),
                      ),

                      // Ортаңғы бөліг / Средняя часть
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: station.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.bgDark,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                station.countryFlag,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Винил тирек сызбалары / Виниловые дорожки
                      ...List.generate(3, (index) {
                        final size = 140.0 + (index * 25);
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Станция ақпаратын құру / Построить информацию о станции
  Widget _buildStationInfo(RadioStation station) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Станция атауы / Название станции
          Text(
            station.name,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Қосымша атаулар / Дополнительные названия
          Text(
            '${station.nameRu} • ${station.nameKz}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Жанр / Жанр
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: station.accentColor.withOpacity(0.2),
              border: Border.all(
                color: station.accentColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              '${station.genreRu} • ${station.genreKz}',
              style: TextStyle(
                color: station.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Сипаттама / Описание
          Text(
            station.descriptionRu,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          Text(
            station.descriptionKz,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Станция опцияларын көрсету / Показать опции станции
  void _showStationOptions(RadioStation station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: AppTheme.deepGlassDecoration(borderRadius: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Жетек / Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.glassWhite,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: station.gradientColors,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        station.countryFlag,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          station.genreRu,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppTheme.borderSubtle, height: 1),

            ListTile(
              leading: Icon(
                Icons.share_rounded,
                color: station.accentColor,
              ),
              title: const Text(
                'Бөлісу / Поделиться',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // Бөлісу функциясы / Функция поделиться
                Share.share(
                  '${station.name} - ${station.genre}\n${station.description}\n\nҚазақстан Радио / Казахстанское Радио',
                  subject: station.name,
                );
              },
            ),

            ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: station.accentColor,
              ),
              title: const Text(
                'Станция туралы / О станции',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _showStationDetails(station);
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Станция мәліметтерін көрсету / Показать детали станции
  void _showStationDetails(RadioStation station) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(24),
          hasGlow: true,
          glowColor: station.accentColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: station.gradientColors,
                  ),
                ),
                child: Center(
                  child: Text(
                    station.countryFlag,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                station.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '${station.nameRu} • ${station.nameKz}',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              _buildDetailRow('Жанр / Жанр', station.genreRu),
              _buildDetailRow('Ағым / Поток', _truncateUrl(station.streamUrl)),
              _buildDetailRow('Танымалдылық / Популярность', '${station.popularity}/100'),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: station.gradientColors,
                    ),
                  ),
                  child: const Text(
                    'Жабу / Закрыть',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Мәліметтер қатарын құру / Построить строку деталей
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// URL-ды қысқарту / Сократить URL
  String _truncateUrl(String url) {
    if (url.length <= 30) return url;
    return '${url.substring(0, 15)}...${url.substring(url.length - 12)}';
  }
}
