//ValueNotifier: hold the data
//ValueListenableBuilder: listen to the data (dont need the setstate)
import 'package:application/data/dark_mode_storage.dart';
import 'package:application/data/favorites_storage.dart';
import 'package:application/data/pokemon.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);
ValueNotifier<List<Map<String, dynamic>>> favoritedPokemonsNotifier =
    ValueNotifier([]);

Future<void> loadFavoritesFromStorage() async {
  final favoriteIds = await FavoritesStorage.loadFavoriteIds();

  if (favoriteIds.isEmpty) {
    favoritedPokemonsNotifier.value = [];
    return;
  }

  final allPokemons = await PokemonData.loadAllPokemons();
  final favorites = allPokemons.where((pokemon) {
    return favoriteIds.contains(pokemon['id'].toString());
  }).toList();

  favoritedPokemonsNotifier.value = List<Map<String, dynamic>>.from(favorites);
}

Future<void> loadDarkModeFromStorage() async {
  final isDarkMode = await DarkModeStorage.loadDarkMode();
  isDarkModeNotifier.value = isDarkMode;
}

void saveFavoritesToStorage() {
  FavoritesStorage.saveFavorites(favoritedPokemonsNotifier.value);
}

void saveDarkModeToStorage() {
  DarkModeStorage.saveDarkMode(isDarkModeNotifier.value);
}
