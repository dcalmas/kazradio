import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../models/radio_station.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/mini_player.dart';
import '../widgets/player_controls.dart';
import '../widgets/station_tile.dart';
import '../widgets/radio_widgets.dart';
import '../widgets/animated_visualizer.dart';
import 'player_screen.dart';

/// Категория элементі / Элемент категории
class CategoryItem {
  final String id;
  final String nameKz;
  final String nameRu;
  final String nameEn;

  CategoryItem(this.id, this.nameKz, this.nameRu, this.nameEn);
}

/// Негізгі экран / Главный экран
/// 
/// Қазақстан радиостанцияларының тізімі / Список радиостанций Казахстана
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  String _selectedCategory = 'all';

  final List<CategoryItem> _categories = [
    CategoryItem('all', 'Барлық', 'Все', 'All'),
    CategoryItem('pop', 'Поп', 'Поп', 'Pop'),
    CategoryItem('rock', 'Рок', 'Рок', 'Rock'),
    CategoryItem('retro', 'Ретро', 'Ретро', 'Retro'),
    CategoryItem('ethnic', 'Этника', 'Этника', 'Ethnic'),
    CategoryItem('electronic', 'Электроника', 'Электроника', 'Electronic'),
    CategoryItem('lounge', 'Лаунж', 'Лаунж', 'Lounge'),
    CategoryItem('classical', 'Классика', 'Классика', 'Classical'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: AppTheme.animationSlow,
    );
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  List<RadioStation> get _filteredStations {
    if (_selectedCategory == 'all') {
      return kazakhstanRadioStations;
    }
    return kazakhstanRadioStations.where((s) => s.category == _selectedCategory).toList();
  }

  String _getCategoryNameKz(String categoryId) {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    return category.nameKz;
  }

  String _getCategoryNameRu(String categoryId) {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    return category.nameRu;
  }

  void _openPlayer() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      _createPageRoute(),
    );
  }

  /// КелPageRoute құру / Создать PageRoute
  Route _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const PlayerScreen();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeOutQuart;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween<double>(begin: 0, end: 1);

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioServiceProvider);
    final hasCurrentStation = audioState.currentStation != null;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Негізгі контент / Основной контент
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar / App Bar
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),

                  // Радио виджеттері / Радио виджеты
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const RadioWidgetLarge(),
                          const SizedBox(height: 12),
                          const RadioWidgetSmall(),
                        ],
                      ),
                    ),
                  ),

                  // Категория фильтрі / Фильтр категорий
                  SliverToBoxAdapter(
                    child: _buildCategoryFilter(),
                  ),

                  // Таңдаулы станциялар / Избранные станции
                  SliverToBoxAdapter(
                    child: _buildFeaturedStations(),
                  ),

                  // Барлық станциялар тақырыбы / Заголовок всех станций
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      _getCategoryNameKz(_selectedCategory),
                      _getCategoryNameRu(_selectedCategory),
                    ),
                  ),

                  // Радиостанциялар тізімі / Список радиостанций
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: _filteredStations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final station = _filteredStations[index];
                        return StationTile(
                          station: station,
                          onTap: () {
                            final audioNotifier = ref.read(audioServiceProvider.notifier);
                            final currentStation = ref.read(audioServiceProvider).currentStation;
                            
                            if (currentStation?.id == station.id && audioState.isPlaying) {
                              _openPlayer();
                            } else {
                              audioNotifier.playStation(station);
                              Future.delayed(const Duration(milliseconds: 300), _openPlayer);
                            }
                          },
                        );
                      },
                    ),
                  ),

                  // Кіші плеер үшін бос орын / Отступ для мини плеера
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: hasCurrentStation ? 160 : 40,
                    ),
                  ),
                ],
              ),

              // Кіші плеер / Мини плеер
              if (hasCurrentStation)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildMiniPlayer(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Категория фильтрін құру / Построить фильтр категорий
  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.nameRu),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category.id;
                  });
                },
                selectedColor: AppTheme.neonViolet.withOpacity(0.3),
                checkmarkColor: AppTheme.neonViolet,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.neonViolet : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: AppTheme.glassWhite.withOpacity(0.1),
                side: BorderSide(
                  color: isSelected ? AppTheme.neonViolet : AppTheme.borderSubtle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Тақырыпты құру / Построить заголовок
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Жоғарғы жол / Верхняя строка
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Логотип / Логотип
              GlassCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonViolet,
                            AppTheme.neonCyan,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.radio,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '🇰🇿 Radio',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Параметрлер түймесі / Кнопка настроек
              GlassCard(
                borderRadius: 12,
                padding: const EdgeInsets.all(10),
                onTap: () {
                  // Параметрлер / Настройки
                  _showSettingsModal();
                },
                child: const Icon(
                  Icons.settings_outlined,
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Анимацияланған тақырып / Анимированный заголовок
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Қош келдіңіз!',
                textStyle: Theme.of(context).textTheme.displaySmall,
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Добро пожаловать!',
                textStyle: Theme.of(context).textTheme.displaySmall,
                speed: const Duration(milliseconds: 100),
              ),
            ],
            isRepeatingAnimation: false,
            totalRepeatCount: 1,
          ),

          const SizedBox(height: 8),

          // Қоштасу мәтіні / Приветственный текст
          Text(
            'Қазақстанның үздік радиостанцияларын тыңдаңыз\nСлушайте лучшие радиостанции Казахстана',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),

          // Аудио визуализатор / Аудио визуализатор
          Center(
            child: AnimatedAudioVisualizer(
              audioLevels: ref.watch(audioServiceProvider).audioLevels,
              barCount: 24,
              maxHeight: 60,
            ),
          ),
        ],
      ),
    );
  }

  /// Таңдаулы станцияларды құру / Построить избранные станции
  Widget _buildFeaturedStations() {
    final featured = featuredStations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Тақырып / Заголовок
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppTheme.neonViolet,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Таңдаулы / Избранное',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),

        // Жолақты тізім / Горизонтальный список
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return StationTile(
                station: featured[index],
                isFeatured: true,
                onTap: () {
                  final audioNotifier = ref.read(audioServiceProvider.notifier);
                  audioNotifier.playStation(featured[index]);
                  Future.delayed(const Duration(milliseconds: 300), _openPlayer);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Бөлім тақырыбын құру / Построить заголовок раздела
  Widget _buildSectionHeader(String titleKz, String titleRu) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [AppTheme.neonViolet, AppTheme.neonCyan],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKz,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  titleRu,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          GlassCard(
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '${kazakhstanRadioStations.length}',
              style: const TextStyle(
                color: AppTheme.neonCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Кіші плеерді құру / Построить мини плеер
  Widget _buildMiniPlayer() {
    return GestureDetector(
      onTap: _openPlayer,
      child: const MiniPlayer(),
    );
  }

  /// Параметрлер модалын көрсету / Показать модал настроек
  void _showSettingsModal() {
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
              child: Text(
                'Параметрлер / Настройки',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const Divider(color: AppTheme.borderSubtle, height: 1),

            // Дыбыс параметрлері / Параметры звука
            ListTile(
              leading: const Icon(
                Icons.volume_up_rounded,
                color: AppTheme.neonCyan,
              ),
              title: const Text(
                'Дыбыс / Звук',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
              ),
              onTap: () {
                Navigator.pop(context);
                // Дыбыс параметрлеріне өту / Перейти к параметрам звука
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.timer_rounded,
                color: AppTheme.neonViolet,
              ),
              title: const Text(
                'Ұйқы таймері / Таймер сна',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
              ),
              onTap: () {
                Navigator.pop(context);
                // Ұйқы таймеріне өту / Перейти к таймеру сна
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: AppTheme.textSecondary,
              ),
              title: const Text(
                'Қосымша туралы / О приложении',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
              ),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Қосымша туралы диалогты көрсету / Показать диалог о приложении
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Логотип / Логотип
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.neonViolet, AppTheme.neonCyan],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonViolet.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.radio,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Қазақстан Радио',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Версия 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              Text(
                'Қазақстанның үздік радиостанцияларының жинағы\n'
                'Коллекция лучших радиостанций Казахстана',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              Text(
                '© 2026 Kazakhstan Radio',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 16),

              // Жабу түймесі / Кнопка закрытия
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
}
