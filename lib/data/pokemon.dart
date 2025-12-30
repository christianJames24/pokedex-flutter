import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PokemonData {
  static List _decodeJson(String response) {
    return json.decode(response);
  }

  static Future<List> loadAllPokemons() async {
    final response = await rootBundle.loadString(
      'assets/datasets/pokemon_data.json',
    );

    return await compute(_decodeJson, response);
  }

  static List filterUnovaPokemons(List allPokemons) {
    return allPokemons.where((p) {
      final int id = int.tryParse(p['id'].toString()) ?? 0;
      return id >= 494 && id <= 649;
    }).toList();
  }

  static List sortPokemons(List pokemons, SortOption sortOption) {
    final sorted = List.from(pokemons);

    switch (sortOption) {
      case SortOption.idAsc:
        sorted.sort((a, b) {
          final idA = int.tryParse(a['id'].toString()) ?? 0;
          final idB = int.tryParse(b['id'].toString()) ?? 0;
          return idA.compareTo(idB);
        });
        break;
      case SortOption.idDesc:
        sorted.sort((a, b) {
          final idA = int.tryParse(a['id'].toString()) ?? 0;
          final idB = int.tryParse(b['id'].toString()) ?? 0;
          return idB.compareTo(idA);
        });
        break;
      case SortOption.nameAsc:
        sorted.sort((a, b) {
          final nameA = a['name'].toString().toLowerCase();
          final nameB = b['name'].toString().toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;
      case SortOption.nameDesc:
        sorted.sort((a, b) {
          final nameA = a['name'].toString().toLowerCase();
          final nameB = b['name'].toString().toLowerCase();
          return nameB.compareTo(nameA);
        });
        break;
    }

    return sorted;
  }

  static List searchPokemons(List pokemons, String query) {
    final q = query.toLowerCase();

    return pokemons.where((p) {
      final name = p['name'].toString().toLowerCase();
      final id = p['id'].toString();

      return name.contains(q) || id.contains(q);
    }).toList();
  }
}

enum SortOption {
  idAsc('ID: Low to High'),
  idDesc('ID: High to Low'),
  nameAsc('Name: A-Z'),
  nameDesc('Name: Z-A');

  const SortOption(this.label);
  final String label;
}
