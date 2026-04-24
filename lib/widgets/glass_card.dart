import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

/// Шыныморфизм картасы виджеті / Виджет стеклянной карточки
/// 
/// 2026 Glassmorphism дизайны бойынша жасалған / Создан по дизайну 2026 Glassmorphism
/// 
/// - BackdropFilter blur(20)
/// - Translucent контейнерлер (opacity 0.15–0.25)
/// - Ақ жиектер (opacity 0.3)
class GlassCard extends StatelessWidget {
  /// Балалар виджеттері / Дочерние виджеты
  final Widget child;
  
  /// Ені / Ширина
  final double? width;
  
  /// Биіктігі / Высота
  final double? height;
  
  /// Бұрыштар дөңгелектулігі / Скругление углов
  final double borderRadius;
  
  /// Шыны түсінің қарқындылығы / Интенсивность цвета стекла
  final double glassOpacity;
  
  /// Жиек түсінің қарқындылығы / Интенсивность цвета границы
  final double borderOpacity;
  
  /// Блюр деңгейі / Уровень размытия
  final double blurSigma;
  
  /// Бастапқы жиек / Начальная граница
  final EdgeInsets margin;
  
  /// Ішкі жиек / Внутренняя граница
  final EdgeInsets padding;
  
  /// Жылулық эффекті / Эффект свечения
  final bool hasGlow;
  
  /// Жылулық түсі / Цвет свечения
  final Color? glowColor;
  
  /// Басу әрекеті / Действие при нажатии
  final VoidCallback? onTap;
  
  /// Ұстап тұру әрекеті / Действие при долгом нажатии
  final VoidCallback? onLongPress;
  
  /// Анимация индексі / Индекс анимации (shimmer)
  final bool isLoading;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.glassOpacity = 0.15,
    this.borderOpacity = 0.3,
    this.blurSigma = 20,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.hasGlow = false,
    this.glowColor,
    this.onTap,
    this.onLongPress,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = child;

    // Shimmer эффектісі / Эффект shimmer
    if (isLoading) {
      cardContent = Shimmer.fromColors(
        baseColor: AppTheme.glassWhite.withOpacity(0.3),
        highlightColor: AppTheme.glassWhite.withOpacity(0.6),
        child: child,
      );
    }

    // Негізгі шыны контейнері / Основной стеклянный контейнер
    Widget glassContainer = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppTheme.borderGlass.withOpacity(borderOpacity),
          width: 1,
        ),
        // Шыны жылулығы / Стеклянное свечение
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppTheme.glowViolet).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.glassWhite.withOpacity(glassOpacity + 0.05),
                  AppTheme.glassBright.withOpacity(glassOpacity),
                ],
              ),
              // Сыртқы жиек / Внешняя граница
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity * 0.5),
                width: 0.5,
              ),
            ),
            child: cardContent,
          ),
        ),
      ),
    );

    // Басу мүмкіндігі / Возможность нажатия
    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: glassContainer,
      );
    }

    return glassContainer;
  }
}

/// Жолақты шыны картасы / Горизонтальная стеклянная карточка
class GlassCardHorizontal extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasGlow;
  final Color? glowColor;
  final EdgeInsets padding;

  const GlassCardHorizontal({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.borderRadius = 20,
    this.onTap,
    this.hasGlow = false,
    this.glowColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: borderRadius,
      padding: padding,
      hasGlow: hasGlow,
      glowColor: glowColor,
      onTap: onTap,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Тік шыны картасы / Вертикальная стеклянная карточка
class GlassCardVertical extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget? footer;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasGlow;
  final Color? glowColor;
  final EdgeInsets padding;

  const GlassCardVertical({
    super.key,
    this.header = const SizedBox.shrink(),
    required this.body,
    this.footer,
    this.borderRadius = 24,
    this.onTap,
    this.hasGlow = false,
    this.glowColor,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: borderRadius,
      padding: padding,
      hasGlow: hasGlow,
      glowColor: glowColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          const SizedBox(height: 12),
          body,
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Градиентті шыны картасы / Градиентная стеклянная карточка
class GradientGlassCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool hasShimmer;

  const GradientGlassCard({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderRadius = 24,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.hasShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ...gradientColors.map((c) => c.withOpacity(0.3)),
            ...gradientColors.reversed.map((c) => c.withOpacity(0.1)),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppTheme.glassWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius - 4),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (hasShimmer) {
      cardContent = Shimmer.fromColors(
        baseColor: gradientColors.first.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.5),
        child: cardContent,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Неуморфизм контейнері / Неуморфный контейнер
class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool isPressed;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.onTap,
    this.width = 80,
    this.height = 80,
    this.isPressed = false,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isPressed = _isPressed || widget.isPressed;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        curve: AppTheme.curveSoft,
        width: widget.width,
        height: widget.height,
        decoration: isPressed
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: AppTheme.glassDeep,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: AppTheme.glassWhite.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(-4, -4),
                  ),
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.glassWhite.withOpacity(0.25),
                    AppTheme.glassBright.withOpacity(0.15),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(6, 6),
                  ),
                  BoxShadow(
                    color: AppTheme.glassWhite.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(-6, -6),
                  ),
                ],
              ),
        child: Center(child: widget.child),
      ),
    );
  }
}
