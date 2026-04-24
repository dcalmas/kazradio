# 🇰🇿 Kazakhstan Radio Player

**Қазақстан Радио Плеері** / **Казахстанское Радио**

A premium, production-ready Flutter radio player application featuring modern 2026 glassmorphism design with fluid animations and background audio playback.

---

## ✨ Features / Мүмкіндіктер / Функции

### Design / Дизайн
- **2026 Glassmorphism UI**: Frosted glass cards with `BackdropFilter` blur(20), translucent containers (opacity 0.15–0.25), subtle white borders (opacity 0.3)
- **Dynamic Gradient Backgrounds**: Animated gradients that shift based on currently playing station
- **Fluid Animations**: Spring physics, particle effects, rotating vinyl animation
- **Neumorphism Hybrid Elements**: For player controls with tactile feedback
- **Dark Mode First**: Deep navy/purple gradient base (#0A0E27 → #1A1040)
- **Glowing Neon Accents**: Primary #7C3AED (violet), secondary #06B6D4 (cyan)

### Audio / Аудио
- **10 Kazakhstan Radio Stations**: Including Qazaq Radio, Hit FM, Retro FM, Europa Plus, NRJ, and more
- **Background Audio**: Continue playing when app is in background using `audio_service` package
- **Audio Visualizer**: FFT-style animated waveform visualization with CustomPainter
- **Sleep Timer**: Set auto-stop timer for bedtime listening
- **Volume Control**: Smooth slider with haptic feedback

### Technical / Техникалық / Техническое
- **State Management**: Riverpod (flutter_riverpod) for reactive state
- **Audio Playback**: just_audio with audio_service for background playback
- **Animations**: Custom painters, AnimatedBuilder, spring physics
- **Comments**: Detailed comments in Kazakh and Russian
- **Null Safety**: Full null safety support

---

## 📱 Screenshots / Скриншоттар / Скриншоты

### Home Screen / Негізгі экран / Главный экран
- Horizontal scrollable featured stations
- Vertical list with glassmorphism cards
- Animated audio visualizer
- Mini player with slide-up animation

### Player Screen / Плеер экраны / Экран плеера
- Large rotating vinyl disc animation
- Pulsing glow effect around artwork
- Full audio visualizer (32 bars FFT-style)
- Sleep timer and volume controls
- Station information with bilingual text

---

## 🎵 Radio Stations / Радиостанциялар / Радиостанции

1. **Qazaq Radio** - National news and culture
2. **Kazakh Radio 1** - Traditional Kazakh music
3. **Hit FM Kazakhstan** - Latest international hits
4. **Retro FM Kazakhstan** - Best hits from 70s-2000s
5. **Europa Plus Kazakhstan** - European pop music
6. **Russkoe Radio Kazakhstan** - Russian pop music
7. **Love Radio Kazakhstan** - Romantic music 24/7
8. **NRJ Kazakhstan** - Dance and EDM
9. **Avtoradio Kazakhstan** - Traffic and car enthusiasts
10. **Power FM Kazakhstan** - Hard rock and metal

---

## 🚀 Getting Started / Жүктеу / Запуск

### Prerequisites
- Flutter SDK 3.4.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode for iOS

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/kazakhstan-radio.git

# Navigate to project
cd kazakhstan-radio

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📁 Project Structure / Жоба құрылымы / Структура проекта

```
lib/
├── main.dart                 # Entry point with Riverpod scope
├── models/
│   └── radio_station.dart    # Station model with all 10 stations
├── screens/
│   ├── home_screen.dart      # Main screen with featured + list
│   └── player_screen.dart    # Full player with visualizer
├── services/
│   └── audio_service.dart    # Audio playback service
├── theme/
│   └── app_theme.dart        # Glassmorphism design system
└── widgets/
    ├── animated_visualizer.dart  # FFT audio visualizer
    ├── glass_card.dart           # Glassmorphism card widget
    ├── player_controls.dart      # Playback controls & mini player
    └── station_tile.dart         # Station list item widget
```

---

## 🎨 Design System / Дизайн жүйесі / Дизайн система

### Colors / Түстер / Цвета

```dart
static const Color bgDark = Color(0xFF0A0E27);
static const Color bgMid = Color(0xFF1A1040);
static const Color glassWhite = Color(0x26FFFFFF);
static const Color neonViolet = Color(0xFF7C3AED);
static const Color neonCyan = Color(0xFF06B6D4);
static const Color glowViolet = Color(0x667C3AED);
```

### Glassmorphism Example
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    ),
  ),
)
```

---

## 📦 Dependencies / Пакеттер / Пакеты

```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  just_audio: ^0.9.40            # Audio playback
  audio_service: ^0.18.15        # Background audio
  just_audio_background: ^0.0.1  # Background audio helper
  audio_session: ^0.1.21         # Audio session management
  cached_network_image: ^3.3.1   # Image caching
  flutter_svg: ^2.0.9            # SVG support
  lottie: ^3.1.0                 # Lottie animations
  glass_kit: ^3.0.0              # Glass effects
  shimmer: ^3.0.0                # Shimmer loading effect
  animated_text_kit: ^4.2.2      # Animated text
```

---

## 🌐 Localization / Локализация / Локализация

The app features bilingual content:
- **Kazakh (Қазақша)**: Native language support
- **Russian (Русский)**: Secondary language support

All radio stations include names and descriptions in both languages.

---

## 🔒 Permissions / Рұқсаттар / Разрешения

### Android
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

### iOS
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

---

## 📝 License / Лицензия / Лицензия

This project is open source. Feel free to use, modify, and distribute.

---

## 👨‍💻 Author / Автор / Автор

**Kazakhstan Radio Player**  
© 2026 - All Rights Reserved

---

## 🙏 Acknowledgments / Алғыс / Благодарности

- Flutter Team for the amazing framework
- just_audio package contributors
- Kazakhstan radio stations for providing streams

---

## 📞 Contact / Байланыс / Контакты

For support or inquiries:  
Email: support@kazakhstanradio.app  
Website: https://kazakhstanradio.app

---

**Қош келдіңіз! / Добро пожаловать! / Welcome!** 🎉
