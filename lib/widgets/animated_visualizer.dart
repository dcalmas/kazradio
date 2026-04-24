import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Анимацияланған аудио визуализатор / Анимированный аудио визуализатор
/// 
/// FFT стиліндегі аудио толқындары / Аудио волны в стиле FFT
/// CustomPainter қолдану арқылы / С использованием CustomPainter
class AnimatedAudioVisualizer extends StatelessWidget {
  /// Аудио деңгейлері / Уровни аудио
  final List<double> audioLevels;
  
  /// Түс градиенті / Цветовой градиент
  final List<Color> colors;
  
  /// Барлар саны / Количество баров
  final int barCount;
  
  /// Барлар арасындағы бос орын / Пространство между барами
  final double spacing;
  
  /// Минималды биіктік / Минимальная высота
  final double minHeight;
  
  /// Максималды биіктік / Максимальная высота
  final double maxHeight;
  
  /// Бардың ені / Ширина бара
  final double barWidth;
  
  /// Бар дөңгелектулігі / Скругление бара
  final double barRadius;

  const AnimatedAudioVisualizer({
    super.key,
    required this.audioLevels,
    this.colors = const [AppTheme.neonViolet, AppTheme.neonCyan],
    this.barCount = 32,
    this.spacing = 4,
    this.minHeight = 5,
    this.maxHeight = 100,
    this.barWidth = 6,
    this.barRadius = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Аудио деңгейлерін қысқарту немесе кеңейту / Уменьшить или увеличить уровни аудио
    List<double> processedLevels;
    if (audioLevels.length >= barCount) {
      processedLevels = audioLevels.take(barCount).toList();
    } else {
      processedLevels = List.generate(
        barCount,
        (index) => audioLevels.isEmpty 
            ? 0.05 
            : audioLevels[index % audioLevels.length],
      );
    }

    return CustomPaint(
      size: Size(
        barCount * (barWidth + spacing) + spacing,
        maxHeight,
      ),
      painter: _AudioVisualizerPainter(
        audioLevels: processedLevels,
        colors: colors,
        spacing: spacing,
        minHeight: minHeight,
        maxHeight: maxHeight,
        barWidth: barWidth,
        barRadius: barRadius,
      ),
    );
  }
}

/// Аудио визуализатор суретшісі / Художник аудио визуализатора
class _AudioVisualizerPainter extends CustomPainter {
  final List<double> audioLevels;
  final List<Color> colors;
  final double spacing;
  final double minHeight;
  final double maxHeight;
  final double barWidth;
  final double barRadius;

  _AudioVisualizerPainter({
    required this.audioLevels,
    required this.colors,
    required this.spacing,
    required this.minHeight,
    required this.maxHeight,
    required this.barWidth,
    required this.barRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // Градиент үшін / Для градиента
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: colors,
    );

    final shaderRect = Rect.fromLTWH(0, 0, barWidth, maxHeight);
    paint.shader = gradient.createShader(shaderRect);

    // Барларды салу / Рисование баров
    final centerY = size.height / 2;
    final totalWidth = audioLevels.length * (barWidth + spacing) - spacing;
    final startX = (size.width - totalWidth) / 2;

    for (int i = 0; i < audioLevels.length; i++) {
      // Аудио деңгейін өңдеу / Обработка уровня аудио
      final level = audioLevels[i].clamp(0.0, 1.0);
      final barHeight = minHeight + (maxHeight - minHeight) * level;

      // Бар позициясы / Позиция бара
      final x = startX + i * (barWidth + spacing);
      final top = centerY - barHeight / 2;
      final bottom = centerY + barHeight / 2;

      // Бар фигурасы / Фигура бара
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, barHeight),
        Radius.circular(barRadius),
      );

      // Синус толқыны эффектісі / Эффект синусоидальной волны
      final waveOffset = sin(i * 0.3) * 5;
      
      // Жылулық эффектісі / Эффект свечения
      final glowPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors.first.withOpacity(0.3 * level)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final glowRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 2, top - 2 + waveOffset, barWidth + 4, barHeight + 4),
        Radius.circular(barRadius + 2),
      );

      canvas.drawRRect(glowRect, glowPaint);

      // Негізгі бар / Основной бар
      final barPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient.createShader(
          Rect.fromLTWH(x, 0, barWidth, size.height),
        );

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top + waveOffset, barWidth, barHeight),
        Radius.circular(barRadius),
      );

      canvas.drawRRect(barRect, barPaint);

      // Жарқын жиегі / Яркая граница
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = Colors.white.withOpacity(0.5 * level);

      canvas.drawRRect(barRect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AudioVisualizerPainter oldDelegate) {
    return oldDelegate.audioLevels != audioLevels;
  }
}

/// Синус толқыны визуализаторы / Синусоидальный визуализатор волн
class SineWaveVisualizer extends StatefulWidget {
  final List<double> audioLevels;
  final Color color;
  final double amplitude;
  final double frequency;
  final double speed;

  const SineWaveVisualizer({
    super.key,
    required this.audioLevels,
    this.color = AppTheme.neonCyan,
    this.amplitude = 30,
    this.frequency = 2,
    this.speed = 1,
  });

  @override
  State<SineWaveVisualizer> createState() => _SineWaveVisualizerState();
}

class _SineWaveVisualizerState extends State<SineWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 100),
          painter: _SineWavePainter(
            animation: _controller.value,
            audioLevels: widget.audioLevels,
            color: widget.color,
            amplitude: widget.amplitude,
            frequency: widget.frequency,
            speed: widget.speed,
          ),
        );
      },
    );
  }
}

/// Синус толқыны суретшісі / Художник синусоидальной волны
class _SineWavePainter extends CustomPainter {
  final double animation;
  final List<double> audioLevels;
  final Color color;
  final double amplitude;
  final double frequency;
  final double speed;

  _SineWavePainter({
    required this.animation,
    required this.audioLevels,
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (audioLevels.isEmpty) return;

    final centerY = size.height / 2;
    final averageLevel = audioLevels.reduce((a, b) => a + b) / audioLevels.length;
    final dynamicAmplitude = amplitude * (0.3 + averageLevel * 0.7);

    // Бірнеше толқындар / Несколько волн
    final waves = [
      _drawWave(canvas, size, centerY, dynamicAmplitude, 0, color),
      _drawWave(canvas, size, centerY, dynamicAmplitude * 0.7, 0.5, color.withOpacity(0.5)),
      _drawWave(canvas, size, centerY, dynamicAmplitude * 0.4, 1, color.withOpacity(0.3)),
    ];

    for (final path in waves) {
      if (path != null) canvas.drawPath(path, _createPaint(color));
    }
  }

  Path? _drawWave(
    Canvas canvas,
    Size size,
    double centerY,
    double amp,
    double phaseOffset,
    Color waveColor,
  ) {
    final path = Path();
    final points = 100;

    for (int i = 0; i <= points; i++) {
      final x = (i / points) * size.width;
      
      // Синус толқыны / Синусоидальная волна
      final time = animation * 2 * pi * speed + phaseOffset;
      final waveX = (i / points) * 2 * pi * frequency;
      
      // Аудио деңгейін қосу / Добавление уровня аудио
      final audioIndex = (i / points * audioLevels.length).toInt().clamp(0, audioLevels.length - 1);
      final audioModulation = 1 + audioLevels[audioIndex] * 0.5;
      
      final y = centerY + sin(waveX + time) * amp * audioModulation;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    return path;
  }

  Paint _createPaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  }

  @override
  bool shouldRepaint(covariant _SineWavePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.audioLevels != audioLevels;
  }
}

/// Айналатын винил диск анимациясы / Анимация вращающегося винилового диска
class RotatingVinyl extends StatefulWidget {
  final bool isPlaying;
  final double size;
  final Widget? albumArt;
  final List<Color>? glowColors;

  const RotatingVinyl({
    super.key,
    this.isPlaying = false,
    this.size = 200,
    this.albumArt,
    this.glowColors,
  });

  @override
  State<RotatingVinyl> createState() => _RotatingVinylState();
}

class _RotatingVinylState extends State<RotatingVinyl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RotatingVinyl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.bgDark,
                AppTheme.bgMid,
              ],
            ),
            boxShadow: widget.isPlaying
                ? [
                    BoxShadow(
                      color: (widget.glowColors?.first ?? AppTheme.glowViolet)
                          .withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: widget.albumArt ??
                    Container(
                      color: AppTheme.glassDeep,
                      child: Icon(
                        Icons.music_note,
                        size: widget.size * 0.3,
                        color: AppTheme.neonCyan,
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Пульсациялық жылулық эффекті / Пульсирующий эффект свечения
class PulsingGlow extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double minRadius;
  final double maxRadius;
  final Duration duration;

  const PulsingGlow({
    super.key,
    required this.child,
    this.colors = const [AppTheme.neonViolet, AppTheme.neonCyan],
    this.minRadius = 20,
    this.maxRadius = 40,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(
      begin: widget.minRadius,
      end: widget.maxRadius,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _radiusAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.colors
                .map(
                  (color) => BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: _radiusAnimation.value,
                    spreadRadius: _radiusAnimation.value * 0.3,
                  ),
                )
                .toList(),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Бөлшектер эффектісі / Эффект частиц
class ParticleEffect extends StatefulWidget {
  final bool isActive;
  final Color color;
  final int particleCount;

  const ParticleEffect({
    super.key,
    this.isActive = false,
    this.color = AppTheme.neonCyan,
    this.particleCount = 20,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _particles = List.generate(
      widget.particleCount,
      (index) => Particle.random(),
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ParticleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

/// Бөлшек моделі / Модель частицы
class Particle {
  final double angle;
  final double distance;
  final double size;
  final double speed;

  Particle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.speed,
  });

  factory Particle.random() {
    return Particle(
      angle: Random().nextDouble() * 2 * pi,
      distance: 30 + Random().nextDouble() * 50,
      size: 2 + Random().nextDouble() * 4,
      speed: 0.5 + Random().nextDouble() * 1,
    );
  }
}

/// Бөлшектер суретшісі / Художник частиц
class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final currentDistance = particle.distance * (progress * particle.speed);
      final x = center.dx + cos(particle.angle) * currentDistance;
      final y = center.dy + sin(particle.angle) * currentDistance;

      final paint = Paint()
        ..color = color.withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
