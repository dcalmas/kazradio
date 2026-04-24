import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Қазақстан радиостанцияларының моделі
/// Модель радиостанций Казахстана
/// 
/// Қазақша және орысша түсініктемелер
/// Описания на казахском и русском языках
@immutable
class RadioStation {
  /// Бірегей идентификатор / Уникальный идентификатор
  final String id;
  
  /// Радиостанция атауы / Название радиостанции
  final String name;
  
  /// Орысша атауы / Название на русском
  final String nameRu;
  
  /// Қазақша атауы / Название на казахском
  final String nameKz;
  
  /// Ақпараттық мәтін / Информационный текст
  final String description;
  
  /// Ақпараттық мәтін орысша / Информационный текст на русском
  final String descriptionRu;
  
  /// Ақпараттық мәтін қазақша / Информационный текст на казахском
  final String descriptionKz;
  
  /// Аудио ағынының URL-ы / URL аудио потока
  final String streamUrl;
  
  /// Станция жанры / Жанр станции
  final String genre;
  
  /// Жанр орысша / Жанр на русском
  final String genreRu;
  
  /// Жанр қазақша / Жанр на казахском
  final String genreKz;
  
  /// Категория / Категория
  final String category;
  
  /// Жарқын түс / Яркий цвет
  final Color accentColor;
  
  /// Градиент түстері / Цвета градиента
  final List<Color> gradientColors;
  
  /// Станция суретінің URL-ы / URL изображения станции
  final String? logoUrl;
  
  /// Станция елтаңбасының URL-ы / URL флага страны станции
  final String countryFlag;
  
  /// Танымалдылық рейтингі / Рейтинг популярности
  final int popularity;
  
  /// Таңдаулы станция ма? / Избранная станция?
  final bool isFeatured;

  const RadioStation({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.streamUrl,
    required this.genre,
    required this.genreRu,
    required this.genreKz,
    required this.category,
    required this.accentColor,
    required this.gradientColors,
    this.logoUrl,
    this.countryFlag = '🇰🇿',
    this.popularity = 0,
    this.isFeatured = false,
  });

  /// Радиостанцияны көшіру / Копирование радиостанции
  RadioStation copyWith({
    String? id,
    String? name,
    String? nameRu,
    String? nameKz,
    String? description,
    String? descriptionRu,
    String? descriptionKz,
    String? streamUrl,
    String? genre,
    String? genreRu,
    String? genreKz,
    String? category,
    Color? accentColor,
    List<Color>? gradientColors,
    String? logoUrl,
    String? countryFlag,
    int? popularity,
    bool? isFeatured,
  }) {
    return RadioStation(
      id: id ?? this.id,
      name: name ?? this.name,
      nameRu: nameRu ?? this.nameRu,
      nameKz: nameKz ?? this.nameKz,
      description: description ?? this.description,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      descriptionKz: descriptionKz ?? this.descriptionKz,
      streamUrl: streamUrl ?? this.streamUrl,
      genre: genre ?? this.genre,
      genreRu: genreRu ?? this.genreRu,
      genreKz: genreKz ?? this.genreKz,
      category: category ?? this.category,
      accentColor: accentColor ?? this.accentColor,
      gradientColors: gradientColors ?? this.gradientColors,
      logoUrl: logoUrl ?? this.logoUrl,
      countryFlag: countryFlag ?? this.countryFlag,
      popularity: popularity ?? this.popularity,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  String toString() {
    return 'RadioStation(id: $id, name: $name, streamUrl: $streamUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioStation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Қазақстан радиостанцияларының тізімі
/// Список радиостанций Казахстана
/// 
/// Барлық 30+ радиостанцияны қамтиды / Включает все 30+ радиостанций
final List<RadioStation> kazakhstanRadioStations = [
  // === POP / ПОП ===
  // 1. Qazaq Radio - Қазақ радиосы
  RadioStation(
    id: 'qazaq_radio',
    name: 'Qazaq Radio',
    nameRu: 'Казахское Радио',
    nameKz: 'Қазақ Радио',
    description: 'Kazakhstan\'s national radio station with news and culture',
    descriptionRu: 'Национальное радио Казахстана с новостями и культурой',
    descriptionKz: 'Қазақстанның ұлттық радиосы, жаңалықтар мен мәдениет',
    streamUrl: 'https://radio-streams.kaztrk.kz/qazradio/qazradio/icecast.audio',
    genre: 'News & Culture',
    genreRu: 'Новости и Культура',
    genreKz: 'Жаңалықтар және Мәдениет',
    category: 'pop',
    accentColor: AppTheme.neonViolet,
    gradientColors: [
      const Color(0xFF7C3AED),
      const Color(0xFF5B21B6),
    ],
    popularity: 100,
    isFeatured: true,
  ),

  // 2. ((beu)) - Қазақ поп музыкасы
  RadioStation(
    id: 'beu_fm',
    name: '((beu))',
    nameRu: '((beu))',
    nameKz: '((beu))',
    description: 'Modern Kazakh pop and ethnic music',
    descriptionRu: 'Современная казахская поп и этническая музыка',
    descriptionKz: 'Заманауи қазақ поп және этникалық музыка',
    streamUrl: 'https://stream.beufm.kz/beufm',
    genre: 'Kazakh Pop',
    genreRu: 'Казахский Поп',
    genreKz: 'Қазақ Поп',
    category: 'pop',
    accentColor: const Color(0xFFD97706),
    gradientColors: [
      const Color(0xFFD97706),
      const Color(0xFFB45309),
    ],
    popularity: 85,
    isFeatured: true,
  ),

  // 3. Love Radio Kazakhstan
  RadioStation(
    id: 'love_radio',
    name: 'Love Radio',
    nameRu: 'Love Radio',
    nameKz: 'Love Radio',
    description: 'Romantic music and love songs 24/7',
    descriptionRu: 'Романтическая музыка и любовные песни 24/7',
    descriptionKz: 'Романтикалық музыка және махаббат әндері 24/7',
    streamUrl: 'https://stream.gakku.tv:8443/love128.mp3',
    genre: 'Love Songs',
    genreRu: 'Любовные Песни',
    genreKz: 'Махаббат Әндері',
    category: 'pop',
    accentColor: const Color(0xFFF472B6),
    gradientColors: [
      const Color(0xFFF472B6),
      const Color(0xFFDB2777),
    ],
    popularity: 80,
    isFeatured: true,
  ),

  // 4. NS
  RadioStation(
    id: 'ns_radio',
    name: 'NS',
    nameRu: 'НС',
    nameKz: 'НС',
    description: 'Popular hits and club music',
    descriptionRu: 'Популярные хиты и клубная музыка',
    descriptionKz: 'Танымал хиттер және клуб музыкасы',
    streamUrl: 'https://listen4.myradio24.com/8162',
    genre: 'Pop Hits',
    genreRu: 'Поп Хиты',
    genreKz: 'Поп Хиттер',
    category: 'pop',
    accentColor: const Color(0xFF3B82F6),
    gradientColors: [
      const Color(0xFF3B82F6),
      const Color(0xFF1D4ED8),
    ],
    popularity: 90,
    isFeatured: true,
  ),

  // 5. ЖАНА FM
  RadioStation(
    id: 'zhana_fm',
    name: 'ЖАНА FM',
    nameRu: 'ЖАНА FM',
    nameKz: 'ЖАНА FM',
    description: 'Russian music and hits',
    descriptionRu: 'Русская музыка и хиты',
    descriptionKz: 'Орыс музыкасы және хиттер',
    streamUrl: 'https://live.zhanafm.kz:8443/zhanafm_onair',
    genre: 'Russian Hits',
    genreRu: 'Русские Хиты',
    genreKz: 'Орыс Хиттер',
    category: 'pop',
    accentColor: const Color(0xFFEC4899),
    gradientColors: [
      const Color(0xFFEC4899),
      const Color(0xFFBE185D),
    ],
    popularity: 75,
    isFeatured: false,
  ),

  // 6. Народное Радио
  RadioStation(
    id: 'narodnoe_radio',
    name: 'Народное Радио',
    nameRu: 'Народное Радио',
    nameKz: 'Халық Радиосы',
    description: 'Pop and Russian music',
    descriptionRu: 'Поп и русская музыка',
    descriptionKz: 'Поп және орыс музыкасы',
    streamUrl: 'http://178.88.167.62:8080/DALA_192',
    genre: 'Pop',
    genreRu: 'Поп',
    genreKz: 'Поп',
    category: 'pop',
    accentColor: const Color(0xFF10B981),
    gradientColors: [
      const Color(0xFF10B981),
      const Color(0xFF059669),
    ],
    popularity: 88,
    isFeatured: true,
  ),

  // 7. Radio Tengri FM
  RadioStation(
    id: 'tengri_fm',
    name: 'Radio Tengri FM',
    nameRu: 'Радио Тенгри FM',
    nameKz: 'Тенгри FM',
    description: 'Classic hits and popular music',
    descriptionRu: 'Классические хиты и популярная музыка',
    descriptionKz: 'Классикалық хиттер және танымал музыка',
    streamUrl: 'http://91.201.214.229:8000/tengrifm',
    genre: 'Hits',
    genreRu: 'Хиты',
    genreKz: 'Хиттер',
    category: 'pop',
    accentColor: const Color(0xFF8B5CF6),
    gradientColors: [
      const Color(0xFF8B5CF6),
      const Color(0xFF6D28D9),
    ],
    popularity: 85,
    isFeatured: true,
  ),

  // 8. Zhulduz Radio
  RadioStation(
    id: 'zhulduz_radio',
    name: 'Zhulduz Radio',
    nameRu: 'Жулдыз Радио',
    nameKz: 'Жұлдыз Радиосы',
    description: 'Classic hits and Russian programming',
    descriptionRu: 'Классические хиты и русские программы',
    descriptionKz: 'Классикалық хиттер және орыс бағдарламалары',
    streamUrl: 'http://91.201.214.229:8000/zhulduz',
    genre: 'Hits',
    genreRu: 'Хиты',
    genreKz: 'Хиттер',
    category: 'pop',
    accentColor: const Color(0xFFF59E0B),
    gradientColors: [
      const Color(0xFFF59E0B),
      const Color(0xFFD97706),
    ],
    popularity: 92,
    isFeatured: true,
  ),

  // 9. Radio SANA
  RadioStation(
    id: 'radio_sana',
    name: 'Radio SANA',
    nameRu: 'Радио SANA',
    nameKz: 'SANA Радиосы',
    description: 'Pop and Russian music',
    descriptionRu: 'Поп и русская музыка',
    descriptionKz: 'Поп және орыс музыкасы',
    streamUrl: 'https://listen4.myradio24.com/radiosana',
    genre: 'Pop',
    genreRu: 'Поп',
    genreKz: 'Поп',
    category: 'pop',
    accentColor: const Color(0xFF06B6D4),
    gradientColors: [
      const Color(0xFF06B6D4),
      const Color(0xFF0891B2),
    ],
    popularity: 70,
    isFeatured: false,
  ),

  // 10. Radio Nostalgie (Kazakhstan)
  RadioStation(
    id: 'radio_nostalgie',
    name: 'Radio Nostalgie',
    nameRu: 'Радио Ностальжи',
    nameKz: 'Ностальжи Радиосы',
    description: 'Pop music and nostalgia',
    descriptionRu: 'Поп музыка и ностальгия',
    descriptionKz: 'Поп музыкасы және ностальгия',
    streamUrl: 'https://listen8.myradio24.com/alexx333',
    genre: 'Pop',
    genreRu: 'Поп',
    genreKz: 'Поп',
    category: 'pop',
    accentColor: const Color(0xFF6366F1),
    gradientColors: [
      const Color(0xFF6366F1),
      const Color(0xFF4F46E5),
    ],
    popularity: 65,
    isFeatured: false,
  ),

  // === ROCK / РОК ===
  // 11. NS-Rock
  RadioStation(
    id: 'ns_rock',
    name: 'NS-Rock',
    nameRu: 'НС Рок',
    nameKz: 'НС Рок',
    description: 'Various rock music station',
    descriptionRu: 'Станция разнообразной рок музыки',
    descriptionKz: 'Әртүрлі рок музыка станциясы',
    streamUrl: 'https://icecast.ns.kz/radions',
    genre: 'Rock',
    genreRu: 'Рок',
    genreKz: 'Рок',
    category: 'rock',
    accentColor: const Color(0xFFEF4444),
    gradientColors: [
      const Color(0xFFEF4444),
      const Color(0xFFB91C1C),
    ],
    popularity: 70,
    isFeatured: true,
  ),

  // 12. Жаңа Rock
  RadioStation(
    id: 'zhana_rock',
    name: 'Жаңа Rock',
    nameRu: 'Жаңа Рок',
    nameKz: 'Жаңа Рок',
    description: 'Alternative rock, classic rock, pop rock',
    descriptionRu: 'Альтернативный рок, классический рок, поп рок',
    descriptionKz: 'Альтернативті рок, классикалық рок, поп рок',
    streamUrl: 'https://live.zhanafm.kz:8443/zhanarock',
    genre: 'Rock',
    genreRu: 'Рок',
    genreKz: 'Рок',
    category: 'rock',
    accentColor: const Color(0xFFDC2626),
    gradientColors: [
      const Color(0xFFDC2626),
      const Color(0xFF991B1B),
    ],
    popularity: 60,
    isFeatured: false,
  ),

  // 13. Tengri FM (Rock)
  RadioStation(
    id: 'tengri_fm_rock',
    name: 'Tengri FM',
    nameRu: 'Тенгри FM',
    nameKz: 'Тенгри FM',
    description: 'Classic rock and rock music',
    descriptionRu: 'Классический рок и рок музыка',
    descriptionKz: 'Классикалық рок және рок музыкасы',
    streamUrl: 'http://91.201.214.229:8000/tengrifm',
    genre: 'Classic Rock',
    genreRu: 'Классический Рок',
    genreKz: 'Классикалық Рок',
    category: 'rock',
    accentColor: const Color(0xFFB91C1C),
    gradientColors: [
      const Color(0xFFB91C1C),
      const Color(0xFF7F1D1D),
    ],
    popularity: 65,
    isFeatured: false,
  ),

  // === RETRO / РЕТРО ===
  // 14. Pioner FM
  RadioStation(
    id: 'pioner_fm',
    name: 'Pioner FM',
    nameRu: 'Пионер FM',
    nameKz: 'Пионер FM',
    description: 'Oldies and Soviet music',
    descriptionRu: 'Ретро и советская музыка',
    descriptionKz: 'Ретро және кеңес музыкасы',
    streamUrl: 'https://live.zhanafm.kz:8443/pionerfm',
    genre: 'Retro / Oldies',
    genreRu: 'Ретро / Старые хиты',
    genreKz: 'Ретро / Ескі хиттер',
    category: 'retro',
    accentColor: const Color(0xFFEC4899),
    gradientColors: [
      const Color(0xFFEC4899),
      const Color(0xFFBE185D),
    ],
    popularity: 88,
    isFeatured: true,
  ),

  // 15. Radio 90s Eurodance
  RadioStation(
    id: 'radio_90s_eurodance',
    name: 'Radio 90s Eurodance',
    nameRu: 'Радио 90s Евродэнс',
    nameKz: '90s Евродэнс Радиосы',
    description: '90s eurodance and online music',
    descriptionRu: 'Евродэнс 90-х и онлайн музыка',
    descriptionKz: '90-жылдардың евродэнсі және онлайн музыка',
    streamUrl: 'https://listen1.myradio24.com/5967',
    genre: '90s Eurodance',
    genreRu: '90s Евродэнс',
    genreKz: '90s Евродэнс',
    category: 'retro',
    accentColor: const Color(0xFF8B5CF6),
    gradientColors: [
      const Color(0xFF8B5CF6),
      const Color(0xFF6D28D9),
    ],
    popularity: 95,
    isFeatured: true,
  ),

  // === ETHNIC / ЭТНИЧЕСКАЯ ===
  // 16. Aspan FM
  RadioStation(
    id: 'aspan_fm',
    name: 'Aspan FM',
    nameRu: 'Аспан FM',
    nameKz: 'Аспан FM',
    description: 'Kazakh ethnic and pop music',
    descriptionRu: 'Казахская этническая и поп музыка',
    descriptionKz: 'Қазақ этникалық және поп музыкасы',
    streamUrl: 'http://77.240.38.228:8000/aspanfm',
    genre: 'Kazakh Music',
    genreRu: 'Казахская Музыка',
    genreKz: 'Қазақ Музыкасы',
    category: 'ethnic',
    accentColor: AppTheme.neonCyan,
    gradientColors: [
      const Color(0xFF06B6D4),
      const Color(0xFF0891B2),
    ],
    popularity: 95,
    isFeatured: true,
  ),

  // 17. Radio Bulbul
  RadioStation(
    id: 'radio_bulbul',
    name: 'Radio Bulbul',
    nameRu: 'Радио Бұлбұл',
    nameKz: 'Бұлбұл Радиосы',
    description: 'Kazakh music station',
    descriptionRu: 'Станция казахской музыки',
    descriptionKz: 'Қазақ музыка станциясы',
    streamUrl: 'https://radiobulbul.stream.laut.fm/radiobulbul',
    genre: 'Kazakh Music',
    genreRu: 'Казахская Музыка',
    genreKz: 'Қазақ Музыкасы',
    category: 'ethnic',
    accentColor: const Color(0xFFFFA500),
    gradientColors: [
      const Color(0xFFFFA500),
      const Color(0xFFFF6B00),
    ],
    popularity: 87,
    isFeatured: true,
  ),

  // 18. Radio TMK
  RadioStation(
    id: 'radio_tmk',
    name: 'Radio TMK',
    nameRu: 'Радио ТМК',
    nameKz: 'ТМК Радиосы',
    description: 'Tatar ethnic and relax music',
    descriptionRu: 'Татарская этническая и расслабляющая музыка',
    descriptionKz: 'Татар этникалық және демалатын музыка',
    streamUrl: 'https://a4.radioheart.ru:9036/RH13170',
    genre: 'Tatar / Ethnic',
    genreRu: 'Татарская / Этническая',
    genreKz: 'Татар / Этникалық',
    category: 'ethnic',
    accentColor: const Color(0xFF14B8A6),
    gradientColors: [
      const Color(0xFF14B8A6),
      const Color(0xFF0F766E),
    ],
    popularity: 55,
    isFeatured: false,
  ),

  // 19. Shalqar
  RadioStation(
    id: 'shalqar',
    name: 'Shalqar',
    nameRu: 'Шалқар',
    nameKz: 'Шалқар',
    description: 'Kazakh national radio',
    descriptionRu: 'Казахское национальное радио',
    descriptionKz: 'Қазақ ұлттық радиосы',
    streamUrl: 'https://radio-streams.kaztrk.kz/shalqar/shalqar/icecast.audio',
    genre: 'Kazakh',
    genreRu: 'Казахский',
    genreKz: 'Қазақ',
    category: 'ethnic',
    accentColor: const Color(0xFF059669),
    gradientColors: [
      const Color(0xFF059669),
      const Color(0xFF047857),
    ],
    popularity: 90,
    isFeatured: true,
  ),

  // === ELECTRONIC / ЭЛЕКТРОННАЯ ===
  // 20. Russian Dance Radio
  RadioStation(
    id: 'russian_dance',
    name: 'Russian Dance Radio',
    nameRu: 'Русское Данс Радио',
    nameKz: 'Орыс Данс Радиосы',
    description: 'Electronic dance music',
    descriptionRu: 'Электронная танцевальная музыка',
    descriptionKz: 'Электронды би музыкасы',
    streamUrl: 'https://lux-radio.com:8015/stream',
    genre: 'Electronic / Dance',
    genreRu: 'Электронная / Танцевальная',
    genreKz: 'Электронды / Би',
    category: 'electronic',
    accentColor: const Color(0xFF8B5CF6),
    gradientColors: [
      const Color(0xFF8B5CF6),
      const Color(0xFF6D28D9),
    ],
    popularity: 85,
    isFeatured: true,
  ),

  // 21. Space Beat
  RadioStation(
    id: 'space_beat',
    name: 'Space Beat',
    nameRu: 'Спейс Бит',
    nameKz: 'Спейс Бит',
    description: 'Alternative and electronic music',
    descriptionRu: 'Альтернативная и электронная музыка',
    descriptionKz: 'Альтернативті және электронды музыка',
    streamUrl: 'https://90116.web.hosting-russia.ru/listen/space_beat/radio.mp3',
    genre: 'Electronic',
    genreRu: 'Электронная',
    genreKz: 'Электронды',
    category: 'electronic',
    accentColor: const Color(0xFF6366F1),
    gradientColors: [
      const Color(0xFF6366F1),
      const Color(0xFF4F46E5),
    ],
    popularity: 50,
    isFeatured: false,
  ),

  // 22. Жаңа MIX
  RadioStation(
    id: 'zhana_mix',
    name: 'Жаңа MIX',
    nameRu: 'Жаңа МИКС',
    nameKz: 'Жаңа МИКС',
    description: 'DJ remix, mix, mixtapes, pop',
    descriptionRu: 'DJ ремиксы, миксы, микстейпы, поп',
    descriptionKz: 'DJ ремикстер, микстер, микстейптер, поп',
    streamUrl: 'https://live.zhanafm.kz:8443/zhanamix',
    genre: 'DJ Mix',
    genreRu: 'DJ Микс',
    genreKz: 'DJ Микс',
    category: 'electronic',
    accentColor: const Color(0xFFEC4899),
    gradientColors: [
      const Color(0xFFEC4899),
      const Color(0xFFBE185D),
    ],
    popularity: 60,
    isFeatured: false,
  ),

  // === CLASSICAL / КЛАССИЧЕСКАЯ ===
  // 23. Radio Classic
  RadioStation(
    id: 'radio_classic',
    name: 'Radio Classic',
    nameRu: 'Радио Классик',
    nameKz: 'Классик Радиосы',
    description: 'Classical music',
    descriptionRu: 'Классическая музыка',
    descriptionKz: 'Классикалық музыка',
    streamUrl: 'https://radio-streams.kaztrk.kz/classic/classic/icecast.audio',
    genre: 'Classical',
    genreRu: 'Классическая',
    genreKz: 'Классикалық',
    category: 'classical',
    accentColor: const Color(0xFF78716C),
    gradientColors: [
      const Color(0xFF78716C),
      const Color(0xFF57534E),
    ],
    popularity: 70,
    isFeatured: false,
  ),

  // === LOUNGE / ЛАУНЖ ===
  // 24. Жаңа Lounge
  RadioStation(
    id: 'zhana_lounge',
    name: 'Жаңа Lounge',
    nameRu: 'Жаңа Лаунж',
    nameKz: 'Жаңа Лаунж',
    description: 'Lounge and relax radio',
    descriptionRu: 'Лаунж и расслабляющее радио',
    descriptionKz: 'Лаунж және демалатын радио',
    streamUrl: 'https://live.zhanafm.kz:8443/zhanalounge',
    genre: 'Lounge',
    genreRu: 'Лаунж',
    genreKz: 'Лаунж',
    category: 'lounge',
    accentColor: const Color(0xFF0D9488),
    gradientColors: [
      const Color(0xFF0D9488),
      const Color(0xFF0F766E),
    ],
    popularity: 55,
    isFeatured: false,
  ),

  // 25. Palmera Blanca radio
  RadioStation(
    id: 'palmera_blanca',
    name: 'Palmera Blanca',
    nameRu: 'Палмера Бланка',
    nameKz: 'Палмера Бланка',
    description: 'Chill, chillout, downtempo, lo-fi, lounge',
    descriptionRu: 'Чилл, чиллаут, даунтемпо, лоу-фай, лаунж',
    descriptionKz: 'Чилл, чиллаут, даунтемпо, лоу-фай, лаунж',
    streamUrl: 'https://daystream.palmerablanca.com/daystream-128.mp3',
    genre: 'Chill / Lounge',
    genreRu: 'Чилл / Лаунж',
    genreKz: 'Чилл / Лаунж',
    category: 'lounge',
    accentColor: const Color(0xFF84CC16),
    gradientColors: [
      const Color(0xFF84CC16),
      const Color(0xFF65A30D),
    ],
    popularity: 45,
    isFeatured: false,
  ),

  // === AUTO / АВТО ===
  // 26. Avtoradio
  RadioStation(
    id: 'avtoradio',
    name: 'Avtoradio',
    nameRu: 'Авторадио',
    nameKz: 'Авторадио',
    description: 'Traffic news and car enthusiasts radio',
    descriptionRu: 'Дорожные новости и радио для автомобилистов',
    descriptionKz: 'Көлік жаңалықтары және автомобильшілер радиосы',
    streamUrl: 'http://178.88.167.62:8080/AVTORADIO_192',
    genre: 'Auto / News',
    genreRu: 'Авто / Новости',
    genreKz: 'Авто / Жаңалықтар',
    category: 'auto',
    accentColor: const Color(0xFF10B981),
    gradientColors: [
      const Color(0xFF10B981),
      const Color(0xFF059669),
    ],
    popularity: 75,
    isFeatured: false,
  ),

  // === DANCE / ТАНЦЕВАЛЬНАЯ ===
  // 27. ВАШЕ РАДИО
  RadioStation(
    id: 'vashe_radio',
    name: 'ВАШЕ РАДИО',
    nameRu: 'ВАШЕ РАДИО',
    nameKz: 'СІЗДІҢ РАДИОСЫ',
    description: 'Dance and pop dance music',
    descriptionRu: 'Танцевальная и поп танцевальная музыка',
    descriptionKz: 'Би және поп би музыкасы',
    streamUrl: 'https://live.zhanafm.kz:8443/vasheradio',
    genre: 'Dance',
    genreRu: 'Танцевальная',
    genreKz: 'Би',
    category: 'dance',
    accentColor: const Color(0xFFF43F5E),
    gradientColors: [
      const Color(0xFFF43F5E),
      const Color(0xFFE11D48),
    ],
    popularity: 65,
    isFeatured: false,
  ),

  // === ISLAMIC / ИСЛАМСКАЯ ===
  // 28. Abdulbasit Abdulsamad
  RadioStation(
    id: 'abdulbasit',
    name: 'Abdulbasit Abdulsamad',
    nameRu: 'Абдулбасит Абдусамад',
    nameKz: 'Абдулбасит Абдусамад',
    description: 'Islamic Quran recitation',
    descriptionRu: 'Исламское чтение Корана',
    descriptionKz: 'Исламдық Құран оқуы',
    streamUrl: 'https://radio.mp3islam.com/listen/abdulbasit/radio.mp3',
    genre: 'Islamic',
    genreRu: 'Исламская',
    genreKz: 'Исламдық',
    category: 'islamic',
    accentColor: const Color(0xFF16A34A),
    gradientColors: [
      const Color(0xFF16A34A),
      const Color(0xFF15803D),
    ],
    popularity: 40,
    isFeatured: false,
  ),

  // 29. The Holy Quran
  RadioStation(
    id: 'holy_quran',
    name: 'The Holy Quran',
    nameRu: 'Священный Коран',
    nameKz: 'Қасиетті Құран',
    description: 'Quran recitation by Sheikh Mahmoud Al-Husari',
    descriptionRu: 'Чтение Корана шейхом Махмудом Аль-Хусари',
    descriptionKz: 'Шейх Махмуд Аль-Хусари Құран оқуы',
    streamUrl: 'https://qurango.net/radio/mahmoud_khalil_alhussary_warsh',
    genre: 'Islamic',
    genreRu: 'Исламская',
    genreKz: 'Исламдық',
    category: 'islamic',
    accentColor: const Color(0xFF22C55E),
    gradientColors: [
      const Color(0xFF22C55E),
      const Color(0xFF16A34A),
    ],
    popularity: 35,
    isFeatured: false,
  ),

  // === OTHER / ДРУГИЕ ===
  // 30. Radio Azamat
  RadioStation(
    id: 'radio_azamat',
    name: 'Radio Azamat',
    nameRu: 'Радио Азамат',
    nameKz: 'Азамат Радиосы',
    description: 'Pop and Russian shanson music',
    descriptionRu: 'Поп и русский шансон',
    descriptionKz: 'Поп және орыс шансоны',
    streamUrl: 'https://listen4.myradio24.com/8162',
    genre: 'Pop / Shanson',
    genreRu: 'Поп / Шансон',
    genreKz: 'Поп / Шансон',
    category: 'other',
    accentColor: const Color(0xFFEF4444),
    gradientColors: [
      const Color(0xFFEF4444),
      const Color(0xFFB91C1C),
    ],
    popularity: 72,
    isFeatured: false,
  ),

  // 31. Radio Рауан
  RadioStation(
    id: 'radio_rauan',
    name: 'Radio Рауан',
    nameRu: 'Радио Рауан',
    nameKz: 'Рауан Радиосы',
    description: 'Kazakh and Russian music',
    descriptionRu: 'Казахская и русская музыка',
    descriptionKz: 'Қазақ және орыс музыкасы',
    streamUrl: 'https://listen4.myradio24.com/rauan',
    genre: 'Mixed',
    genreRu: 'Смешанная',
    genreKz: 'Аралас',
    category: 'other',
    accentColor: const Color(0xFFA855F7),
    gradientColors: [
      const Color(0xFFA855F7),
      const Color(0xFF7E22CE),
    ],
    popularity: 50,
    isFeatured: false,
  ),

  // 32. Радио Талап
  RadioStation(
    id: 'radio_talap',
    name: 'Радио Талап',
    nameRu: 'Радио Талап',
    nameKz: 'Талап Радиосы',
    description: 'Kazakh and Russian music',
    descriptionRu: 'Казахская и русская музыка',
    descriptionKz: 'Қазақ және орыс музыкасы',
    streamUrl: 'https://okeyradio.ru/okey',
    genre: 'Mixed',
    genreRu: 'Смешанная',
    genreKz: 'Аралас',
    category: 'other',
    accentColor: const Color(0xFFF97316),
    gradientColors: [
      const Color(0xFFF97316),
      const Color(0xFFEA580C),
    ],
    popularity: 45,
    isFeatured: false,
  ),
];

/// Таңдаулы радиостанциялар / Избранные радиостанции
List<RadioStation> get featuredStations => 
    kazakhstanRadioStations.where((s) => s.isFeatured).toList();

/// Танымалдық бойынша сұрыпталған / Отсортированные по популярности
List<RadioStation> get stationsByPopularity => 
    List<RadioStation>.from(kazakhstanRadioStations)
      ..sort((a, b) => b.popularity.compareTo(a.popularity));

/// Станцияны ID бойынша табу / Найти станцию по ID
RadioStation? findStationById(String id) {
  try {
    return kazakhstanRadioStations.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
}
