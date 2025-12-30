import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _key = 'favorited_pokemons';

  static Future<void> saveFavorites(
    List<Map<String, dynamic>> favorites,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final ids = favorites.map((pokemon) => pokemon['id'].toString()).toList();
    await prefs.setStringList(_key, ids);
  }

  static Future<List<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
