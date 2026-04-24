import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';
import '../services/equalizer_service.dart';
import '../services/quality_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

/// Баптаулар экраны / Экран настроек
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final EqualizerService _equalizerService = EqualizerService();
  final QualityService _qualityService = QualityService();
  
  double _bass = 0.0;
  double _treble = 0.0;
  double _mid = 0.0;
  bool _lowTrafficMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _equalizerService.loadSettings();
    await _qualityService.loadSettings();
    
    if (mounted) {
      setState(() {
        _bass = _equalizerService.bass;
        _treble = _equalizerService.treble;
        _mid = _equalizerService.mid;
        _lowTrafficMode = _qualityService.lowTrafficMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioServiceProvider);
    final audioNotifier = ref.read(audioServiceProvider.notifier);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / Заголовок
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.neonViolet, AppTheme.neonCyan],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonViolet.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Баптаулар',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Настройки',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sleep Timer / Таймер сна
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bedtime,
                          color: AppTheme.neonCyan,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Ұйқы таймері / Таймер сна',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (audioState.sleepTimer != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Қалған уақыт / Осталось: ${audioState.remainingTime?.inMinutes ?? 0} мин',
                            style: TextStyle(
                              color: AppTheme.neonCyan,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              audioNotifier.cancelSleepTimer();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Өшіру / Отменить'),
                          ),
                        ],
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTimerButton('5 мин', const Duration(minutes: 5), audioNotifier),
                          _buildTimerButton('10 мин', const Duration(minutes: 10), audioNotifier),
                          _buildTimerButton('15 мин', const Duration(minutes: 15), audioNotifier),
                          _buildTimerButton('30 мин', const Duration(minutes: 30), audioNotifier),
                          _buildTimerButton('1 сағат', const Duration(hours: 1), audioNotifier),
                          _buildTimerButton('2 сағат', const Duration(hours: 2), audioNotifier),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Equalizer / Эквалайзер
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.equalizer,
                          color: AppTheme.neonViolet,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Эквалайзер / Эквалайзер',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSlider('Bass / Бас', _bass, -10, 10, (value) async {
                      await _equalizerService.setBass(value);
                      setState(() => _bass = value);
                    }),
                    const SizedBox(height: 16),
                    _buildSlider('Mid / Середина', _mid, -10, 10, (value) async {
                      await _equalizerService.setMid(value);
                      setState(() => _mid = value);
                    }),
                    const SizedBox(height: 16),
                    _buildSlider('Treble / Требл', _treble, -10, 10, (value) async {
                      await _equalizerService.setTreble(value);
                      setState(() => _treble = value);
                    }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _equalizerService.reset();
                        await _loadSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textSecondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Қалпына келтіру / Сбросить'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Low Traffic Mode / Режим низкого трафика
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.network_cell,
                          color: AppTheme.neonCyan,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Төмен трафик режимі / Режим низкого трафика',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _lowTrafficMode,
                      onChanged: (value) async {
                        await _qualityService.toggleLowTrafficMode();
                        await _loadSettings();
                      },
                      activeColor: AppTheme.neonCyan,
                      title: Text(
                        'Қосу / Включить',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Автоматты түрде битрейтті төмендетеді / Автоматически понижает битрейт',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Volume / Громкость
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.volume_up,
                          color: AppTheme.neonViolet,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Дыбыс / Громкость',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: audioState.volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: AppTheme.neonViolet,
                      onChanged: (value) {
                        audioNotifier.setVolume(value);
                      },
                    ),
                    Text(
                      '${(audioState.volume * 100).toInt()}%',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                color: AppTheme.neonViolet,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppTheme.neonViolet,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTimerButton(String label, Duration duration, dynamic audioNotifier) {
    return ElevatedButton(
      onPressed: () => audioNotifier.setSleepTimer(duration),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.neonCyan.withOpacity(0.2),
        foregroundColor: AppTheme.neonCyan,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppTheme.neonCyan.withOpacity(0.3)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
