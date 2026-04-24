import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/radio_station.dart';

/// Сүйікті станциялар қызметі / Сервис любимых станций
class FavoritesService {
  static const String _favoritesKey = 'favorite_stations';

  /// Сүйікті станцияларды алу / Получить любимые станции
  static Future<List<String>> getFavoriteStationIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites;
  }

  /// Станцияны сүйіктілерге қосу / Добавить станцию в любимые
  static Future<void> addToFavorites(RadioStation station) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteStationIds();
    
    if (!favorites.contains(station.id)) {
      favorites.add(station.id);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// Станцияны сүйіктілерден жою / Удалить станцию из любимых
  static Future<void> removeFromFavorites(RadioStation station) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteStationIds();
    
    favorites.remove(station.id);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Станция сүйікті ме / Является ли станция любимой
  static Future<bool> isFavorite(RadioStation station) async {
    final favorites = await getFavoriteStationIds();
    return favorites.contains(station.id);
  }

  /// Сүйікті станциялар тізімін алу / Получить список любимых станций
  static Future<List<RadioStation>> getFavoriteStations() async {
    final favoriteIds = await getFavoriteStationIds();
    return kazakhstanRadioStations.where((station) => favoriteIds.contains(station.id)).toList();
  }

  /// Сүйіктілерді ауыстыру / Переключить любимые
  static Future<void> toggleFavorite(RadioStation station) async {
    final isFav = await isFavorite(station);
    if (isFav) {
      await removeFromFavorites(station);
    } else {
      await addToFavorites(station);
    }
  }
}

/// Favorites provider / Провайдер избранного
final favoritesProvider = FutureProvider<List<RadioStation>>((ref) async {
  return await FavoritesService.getFavoriteStations();
});

/// Favorites notifier provider / Провайдер нотификатора избранного
class FavoritesNotifier extends StateNotifier<List<RadioStation>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesService.getFavoriteStations();
    state = favorites;
  }

  Future<void> refresh() async {
    await _loadFavorites();
  }

  Future<void> toggleFavorite(RadioStation station) async {
    await FavoritesService.toggleFavorite(station);
    await _loadFavorites();
  }
}

final favoritesNotifierProvider = StateNotifierProvider<FavoritesNotifier, List<RadioStation>>((ref) {
  return FavoritesNotifier();
});
