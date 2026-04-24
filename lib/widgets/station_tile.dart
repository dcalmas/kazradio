import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/radio_station.dart';
import '../services/audio_service.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Радиостанция картасы / Карточка радиостанции
/// 
/// 2026 Glassmorphism дизайны / Дизайн 2026 Glassmorphism
class StationTile extends ConsumerStatefulWidget {
  final RadioStation station;
  final bool isHorizontal;
  final bool isFeatured;
  final VoidCallback? onTap;

  const StationTile({
    super.key,
    required this.station,
    this.isHorizontal = false,
    this.isFeatured = false,
    this.onTap,
  });

  @override
  ConsumerState<StationTile> createState() => _StationTileState();
}

class _StationTileState extends ConsumerState<StationTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppTheme.animationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FavoritesService.isFavorite(widget.station);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final favoritesNotifier = ref.read(favoritesNotifierProvider.notifier);
    await favoritesNotifier.toggleFavorite(widget.station);
    await _loadFavoriteStatus();
  }

  void _handleTap() {
    _scaleController.forward().then((_) => _scaleController.reverse());
    
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      final audioNotifier = ref.read(audioServiceProvider.notifier);
      final currentStation = ref.read(audioServiceProvider).currentStation;
      
      if (currentStation?.id == widget.station.id) {
        audioNotifier.togglePlayPause();
      } else {
        audioNotifier.playStation(widget.station);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioServiceProvider);
    final isPlaying = audioState.currentStation?.id == widget.station.id &&
        audioState.isPlaying;
    final isCurrent = audioState.currentStation?.id == widget.station.id;

    if (widget.isHorizontal) {
      return _buildHorizontalCard(isPlaying, isCurrent);
    }

    if (widget.isFeatured) {
      return _buildFeaturedCard(isPlaying, isCurrent);
    }

    return _buildVerticalCard(isPlaying, isCurrent);
  }

  /// Жолақты картаны құру / Построить горизонтальную карточку
  Widget _buildHorizontalCard(bool isPlaying, bool isCurrent) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: GlassCard(
              width: 280,
              borderRadius: 20,
              hasGlow: isPlaying,
              glowColor: widget.station.accentColor,
              glassOpacity: isCurrent ? 0.25 : 0.15,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Станция суреті / Изображение станции
                  _StationAvatar(
                    station: widget.station,
                    size: 64,
                    isPlaying: isPlaying,
                  ),
                  const SizedBox(width: 14),
                  
                  // Станция ақпараты / Информация о станции
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.station.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.station.genreRu,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusIndicator(isPlaying, isCurrent),
                      ],
                    ),
                  ),
                  // Favorite button / Кнопка любимого
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Таңдаулы картаны құру / Построить избранную карточку
  Widget _buildFeaturedCard(bool isPlaying, bool isCurrent) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: GradientGlassCard(
              width: 180,
              gradientColors: widget.station.gradientColors,
              borderRadius: 24,
              hasShimmer: isPlaying,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Станция суреті / Изображение станции
                  _StationAvatar(
                    station: widget.station,
                    size: 80,
                    isPlaying: isPlaying,
                  ),
                  const SizedBox(height: 16),
                  
                  // Станция атауы / Название станции
                  Text(
                    widget.station.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Жанр / Жанр
                  Text(
                    widget.station.genreRu,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  
                  // Күй индикаторы / Индикатор состояния
                  _buildStatusIndicator(isPlaying, isCurrent),
                  
                  const SizedBox(height: 8),
                  
                  // Favorite button / Кнопка любимого
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Тік картаны құру / Построить вертикальную карточку
  Widget _buildVerticalCard(bool isPlaying, bool isCurrent) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: GlassCard(
              borderRadius: 20,
              hasGlow: isPlaying,
              glowColor: widget.station.accentColor,
              glassOpacity: isCurrent ? 0.25 : 0.15,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Станция суреті / Изображение станции
                  _StationAvatar(
                    station: widget.station,
                    size: 56,
                    isPlaying: isPlaying,
                  ),
                  const SizedBox(width: 14),
                  
                  // Станция ақпараты / Информация о станции
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.station.name,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              _buildPlayingIndicator(isPlaying),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.station.genreRu,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.station.countryFlag} ${widget.station.nameKz}',
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Favorite button / Кнопка любимого
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : AppTheme.textSecondary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Ойнату белгішесі / Иконка воспроизведения
                  if (!isCurrent)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.station.accentColor.withOpacity(0.2),
                        border: Border.all(
                          color: widget.station.accentColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: widget.station.accentColor,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Күй индикаторын құру / Построить индикатор состояния
  Widget _buildStatusIndicator(bool isPlaying, bool isCurrent) {
    if (!isCurrent) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isPlaying
            ? widget.station.accentColor.withOpacity(0.2)
            : AppTheme.glassWhite.withOpacity(0.2),
        border: Border.all(
          color: isPlaying
              ? widget.station.accentColor
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPlaying)
            _AnimatedBars(color: widget.station.accentColor)
          else
            Icon(
              Icons.pause_rounded,
              color: AppTheme.textSecondary,
              size: 12,
            ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isPlaying ? 'Ойнатылуда' : 'Кідіртілген',
              style: TextStyle(
                color: isPlaying
                    ? widget.station.accentColor
                    : AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Ойнату индикаторын құру / Построить индикатор воспроизведения
  Widget _buildPlayingIndicator(bool isPlaying) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying
            ? widget.station.accentColor.withOpacity(0.2)
            : AppTheme.glassWhite.withOpacity(0.2),
      ),
      child: isPlaying
          ? _AnimatedBars(color: widget.station.accentColor, barCount: 3)
          : Icon(
              Icons.pause_rounded,
              color: AppTheme.textSecondary,
              size: 14,
            ),
    );
  }
}

/// Станция аватары / Аватар станции
class _StationAvatar extends StatelessWidget {
  final RadioStation station;
  final double size;
  final bool isPlaying;

  const _StationAvatar({
    required this.station,
    required this.size,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        gradient: LinearGradient(
          colors: station.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: station.accentColor.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          station.countryFlag,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}

/// Анимацияланған толқындар барлары / Анимированные полосы волн
class _AnimatedBars extends StatefulWidget {
  final Color color;
  final int barCount;

  const _AnimatedBars({
    required this.color,
    this.barCount = 4,
  });

  @override
  State<_AnimatedBars> createState() => _AnimatedBarsState();
}

class _AnimatedBarsState extends State<_AnimatedBars>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.barCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (index * 100)),
      )..repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.barCount, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 3,
              height: 4 + (_controllers[index].value * 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: widget.color,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Жүктелуде индикаторы / Индикатор загрузки
class StationTileShimmer extends StatelessWidget {
  final bool isHorizontal;

  const StationTileShimmer({
    super.key,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: isHorizontal ? 280 : null,
      borderRadius: 20,
      isLoading: true,
      glassOpacity: 0.15,
      child: isHorizontal ? _buildHorizontalShimmer() : _buildVerticalShimmer(),
    );
  }

  Widget _buildHorizontalShimmer() {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalShimmer() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Бос орын станциясы / Пустая станция (placeholder)
class EmptyStationTile extends StatelessWidget {
  final String message;

  const EmptyStationTile({
    super.key,
    this.message = 'Станциялар жоқ\nНет станций',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.radio_outlined,
            size: 48,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
