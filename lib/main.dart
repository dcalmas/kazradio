import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Экрандар / Экраны
import 'screens/main_screen.dart';

// Тема / Тема
import 'theme/app_theme.dart';

/// Қазақстан радио плеерінің негізгі кіріс нүктесі
/// Главная точка входа для радио плеера Казахстана
Future<void> main() async {
  // Flutter виджеттерін инициализациялау / Инициализация Flutter виджетов
  WidgetsFlutterBinding.ensureInitialized();

  // Жүйелік UI стилін орнату / Установка системного UI стиля
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Жүйелік навигация толық экран режимінде / Системная навигация в полноэкранном режиме
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  runApp(
    const ProviderScope(
      child: KazakhstanRadioApp(),
    ),
  );
}

/// Негізгі қосымша виджеті / Основной виджет приложения
class KazakhstanRadioApp extends StatelessWidget {
  const KazakhstanRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Қазақстан Радио / Казахстанское Радио',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}
