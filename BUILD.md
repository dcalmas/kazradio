# Build Guide / Құру нұсқаулығы / Руководство по сборке

## ✅ Prerequisites / Қажеттіліктер / Требования

1. **Flutter SDK** 3.4.0 or higher
2. **Android SDK** (for Android builds)
3. **Xcode** 15+ (for iOS builds, macOS only)
4. **CocoaPods** (for iOS dependencies)

## 🚀 Quick Build / Жылдам құру / Быстрая сборка

### Android APK
```bash
cd c:\Users\dcalmas\Documents\radio
flutter clean
flutter pub get
flutter build apk --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

**Output:** `build/app/outputs/bundle/release/app-release.aab`

### iOS (macOS only)
```bash
cd ios
pod install
cd ..
flutter build ios --release
```

## 🔧 Troubleshooting / Мәселелерді шешу / Устранение проблем

### 1. Gradle errors
```bash
cd android
./gradlew clean
./gradlew build
cd ..
```

### 2. iOS CocoaPods errors
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### 3. Clean and rebuild
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter build apk
```

## 📱 Tested Configurations / Тексерілген конфигурациялар / Проверенные конфигурации

| Platform | Minimum | Recommended |
|----------|---------|-------------|
| Android | API 21 (Android 5.0) | API 33+ |
| iOS | 13.0 | 16.0+ |

## 📦 Build Outputs / Құру нәтижелері / Результаты сборки

### Android
- **APK:** `build/app/outputs/flutter-apk/`
- **AAB:** `build/app/outputs/bundle/release/`

### iOS
- **IPA:** Xcode архиві арқылы құрылуы керек / Must be built via Xcode archive

## 🐛 Common Issues / Жиі кездесетін мәселелер / Частые проблемы

### Issue 1: `local.properties not found`
**Solution:** `flutter pub get` автоматты түрде жасайды / automatically creates it

### Issue 2: `CocoaPods not installed` (iOS)
**Solution:** 
```bash
sudo gem install cocoapods
```

### Issue 3: `kotlin-gradle-plugin` version mismatch
**Solution:** Android Studio арқылы жаңарту / Update via Android Studio

## 📋 Pre-build Checklist / Құру алдындағы тексеру / Чек-лист перед сборкой

- [ ] `flutter doctor` shows all green checks
- [ ] `flutter pub get` completed successfully
- [ ] For iOS: `pod install` completed in ios/ folder
- [ ] Android SDK path configured in Android Studio
- [ ] Keystore configured for release builds (Android)

## 📞 Support / Қолдау / Поддержка

Если билд қателік берсе, керек файлдар толықтығын тексеріңіз:
```bash
flutter doctor -v
```
