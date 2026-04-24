import 'package:flutter/material.dart';

/// Қазақстан радио плеерінің дизайн жүйесі
/// Дизайн система радио плеера Казахстана
/// Glassmorphism Design System 2026
class AppTheme {
  // === НЕГІЗГІ ТҮСТЕР / ОСНОВНЫЕ ЦВЕТА ===
  
  /// Қараңғы фон / Темный фон
  static const Color bgDark = Color(0xFF0A0E27);
  
  /// Орташа фон / Средний фон
  static const Color bgMid = Color(0xFF1A1040);
  
  /// Жарық фон / Светлый фон
  static const Color bgLight = Color(0xFF2D1B69);

  /// Шыны ақ түсі / Стеклянный белый цвет
  static const Color glassWhite = Color(0x26FFFFFF); // 15% opacity
  
  /// Терең шыны түсі / Глубокий стеклянный цвет
  static const Color glassDeep = Color(0x40FFFFFF); // 25% opacity
  
  /// Жарқын шыны түсі / Яркий стеклянный цвет
  static const Color glassBright = Color(0x1AFFFFFF); // 10% opacity

  /// Неон күлгін түс / Неоновый фиолетовый
  static const Color neonViolet = Color(0xFF7C3AED);
  
  /// Неон көк түс / Неоновый голубой
  static const Color neonCyan = Color(0xFF06B6D4);
  
  /// Неон қызыл түс / Неоновый розовый
  static const Color neonPink = Color(0xFFF472B6);

  /// Күлгін жылулығы / Фиолетовое свечение
  static const Color glowViolet = Color(0x667C3AED);
  
  /// Көк жылулығы / Голубое свечение
  static const Color glowCyan = Color(0x6606B6D4);
  
  /// Қызыл жылулығы / Розовое свечение
  static const Color glowPink = Color(0x66F472B6);

  /// Ақ мәтін / Белый текст
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Түңсірт ақ мәтін / Приглушенный белый текст
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% opacity
  
  /// Тағы да түңсірт мәтін / Еще более приглушенный текст
  static const Color textTertiary = Color(0x80FFFFFF); // 50% opacity

  /// Шыны жиек түсі / Цвет стеклянной границы
  static const Color borderGlass = Color(0x4DFFFFFF); // 30% opacity
  
  /// Тегіс жиек түсі / Гладкий цвет границы
  static const Color borderSubtle = Color(0x1AFFFFFF); // 10% opacity

  // === ГРАДИЕНТТЕР / ГРАДИЕНТЫ ===
  
  /// Негізгі фон градиенті / Основной градиент фона
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      bgDark,
      bgMid,
      Color(0xFF0F0A3D),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Күлгін градиент / Фиолетовый градиент
  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      neonViolet,
      Color(0xFF6D28D9),
      Color(0xFF5B21B6),
    ],
  );

  /// Көк градиент / Голубой градиент
  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      neonCyan,
      Color(0xFF0891B2),
      Color(0xFF0E7490),
    ],
  );

  /// Неон градиент / Неоновый градиент
  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      neonViolet,
      neonCyan,
    ],
  );

  /// Жылулық градиент / Градиент свечения
  static const RadialGradient glowGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      glowViolet,
      Colors.transparent,
    ],
  );

  /// Шыны градиент / Стеклянный градиент
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      glassWhite,
      glassBright,
    ],
  );

  // === ШЕТТЕР ТҮСТЕРІ / СТИЛИ ТЕКСТА ===
  
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -1,
    ),
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textTertiary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textSecondary,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: textTertiary,
      letterSpacing: 0.5,
    ),
  );

  // === ТЕМНАЯ ТЕМА / ТЕМНАЯ ТЕМА ===
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: neonViolet,
        secondary: neonCyan,
        surface: glassWhite,
        background: bgDark,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: neonViolet,
        inactiveTrackColor: glassWhite,
        thumbColor: neonCyan,
        overlayColor: glowCyan,
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          pressedElevation: 8,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 16,
        ),
      ),
      cardTheme: CardThemeData(
        color: glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonViolet,
        foregroundColor: textPrimary,
        elevation: 8,
        hoverElevation: 12,
      ),
    );
  }

  // === ШЫНЫМОРФИЗМ БЕЛГІЛЕРІ / СТИЛИ СТЕКЛОМОРФИЗМА ===
  
  /// Шыны контейнер декорациясы / Декорация стеклянного контейнера
  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    Color? customColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: customColor ?? glassWhite,
      border: Border.all(
        color: borderGlass,
        width: 1,
      ),
    );
  }

  /// Терең шыны декорациясы / Декорация глубокого стекла
  static BoxDecoration deepGlassDecoration({
    double borderRadius = 24,
    Color? customColor,
    Border? customBorder,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: customColor ?? glassDeep,
      border: customBorder ?? Border.all(
        color: borderGlass,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: glowViolet.withOpacity(0.2),
          blurRadius: 30,
          spreadRadius: 5,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  /// Неуморфизм декорациясы / Декорация неуморфизма
  static BoxDecoration neumorphismDecoration({
    double borderRadius = 20,
    bool isPressed = false,
  }) {
    if (isPressed) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: glassDeep,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(3, 3),
          ),
          BoxShadow(
            color: glassWhite.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(-3, -3),
          ),
        ],
      );
    }
    
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          glassWhite.withOpacity(0.3),
          glassBright.withOpacity(0.1),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(5, 5),
        ),
        BoxShadow(
          color: glassWhite.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(-5, -5),
        ),
      ],
    );
  }

  /// Жылулық контейнер декорациясы / Декорация контейнера с свечением
  static BoxDecoration glowDecoration({
    double borderRadius = 20,
    Color? glowColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (glowColor ?? neonViolet).withOpacity(0.3),
          (glowColor ?? neonCyan).withOpacity(0.1),
        ],
      ),
      border: Border.all(
        color: (glowColor ?? neonViolet).withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: (glowColor ?? glowViolet).withOpacity(0.4),
          blurRadius: 40,
          spreadRadius: 5,
        ),
      ],
    );
  }

  // === АНИМАЦИЯ ТАЙМИНГТЕРІ / ТАЙМИНГИ АНИМАЦИЙ ===
  
  /// Жылдам анимация / Быстрая анимация
  static const Duration animationFast = Duration(milliseconds: 150);
  
  /// Қалыпты анимация / Нормальная анимация
  static const Duration animationNormal = Duration(milliseconds: 300);
  
  /// Баяу анимация / Медленная анимация
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  /// Өте баяу анимация / Очень медленная анимация
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  /// Жұмсақ кривизмалар / Мягкие кривые
  static const Curve curveSoft = Curves.easeInOut;
  
  /// Пружиналық кривизмалар / Пружинные кривые
  static const Curve curveSpring = Curves.elasticOut;
  
  /// Тегіс кривизмалар / Плавные кривые
  static const Curve curveSmooth = Curves.easeOutQuart;
  
  /// Дөрекі кривизмалар / Резкие кривые
  static const Curve curveSharp = Curves.easeInOutCubic;
}
