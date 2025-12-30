import 'package:application/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:application/data/string_extension.dart';
import 'package:application/data/pokemon.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.pokemon});

  final Map<String, dynamic> pokemon;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List allPokemons = [];
  late Map<String, dynamic> currentPokemon;
  int currentIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    currentPokemon = widget.pokemon;
    loadPokemons();
  }

  Future<void> loadPokemons() async {
    final List data = await PokemonData.loadAllPokemons();
    final List unova = PokemonData.filterUnovaPokemons(data);
    final List sorted = PokemonData.sortPokemons(unova, SortOption.idAsc);

    if (mounted) {
      setState(() {
        allPokemons = sorted;
        currentIndex = sorted.indexWhere(
          (p) => p['id'].toString() == widget.pokemon['id'].toString(),
        );
        if (currentIndex == -1) currentIndex = 0;
        loading = false;
      });
    }
  }

  void goToPrevious() {
    if (allPokemons.isEmpty) return;

    setState(() {
      currentIndex =
          (currentIndex - 1 + allPokemons.length) % allPokemons.length;
      currentPokemon = allPokemons[currentIndex];
    });
  }

  void goToNext() {
    if (allPokemons.isEmpty) return;

    setState(() {
      currentIndex = (currentIndex + 1) % allPokemons.length;
      currentPokemon = allPokemons[currentIndex];
    });
  }

  void toggleFavorite() {
    final favorites = List<Map<String, dynamic>>.from(
      favoritedPokemonsNotifier.value,
    );
    final index = favorites.indexWhere(
      (p) => p['id'].toString() == currentPokemon['id'].toString(),
    );

    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(currentPokemon);
    }

    favoritedPokemonsNotifier.value = favorites;
    saveFavoritesToStorage();
  }

  bool isFavorited() {
    return favoritedPokemonsNotifier.value.any(
      (p) => p['id'].toString() == currentPokemon['id'].toString(),
    );
  }

  int get previousIndex =>
      (currentIndex - 1 + allPokemons.length) % allPokemons.length;
  int get nextIndex => (currentIndex + 1) % allPokemons.length;

  @override
  Widget build(BuildContext context) {
    final typesList = (currentPokemon['types'] as String).split(',');
    final abilitiesList = (currentPokemon['abilities'] as String).split(',');
    final movesList = (currentPokemon['moves'] as String).split(',');
    final statsList = (currentPokemon['stats'] as String).split(',');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: favoritedPokemonsNotifier,
            builder: (context, favorites, child) {
              final isFav = isFavorited();
              return IconButton(
                onPressed: toggleFavorite,
                icon: Icon(isFav ? Icons.star : Icons.star_border),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        (currentPokemon['name'] as String).capitalize2(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '#${currentPokemon['id']?.toString() ?? 'Unknown ID'}',
                      ),
                      SizedBox(height: 25),
                      Image.asset(
                        'assets/images/pokemon/${currentPokemon['id']}.png',
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          );
                        },
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Type(s)',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: typesList.map((type) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/types/${type.trim()}.png',
                              fit: BoxFit.contain,
                              height: 15,
                              excludeFromSemantics: true,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Base Experience:',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        currentPokemon['base_experience']?.toString() ??
                            'Unknown',
                      ),
                      Text(
                        'Height:',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(currentPokemon['height']?.toString() ?? 'Unknown'),
                      Text(
                        'Weight:',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(currentPokemon['weight']?.toString() ?? 'Unknown'),
                      SizedBox(height: 25),
                      Text(
                        'Abilities',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(abilitiesList.join(', ').capitalize2()),
                      SizedBox(height: 25),
                      Text(
                        'Moves',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(movesList.join(', ').capitalize2()),
                      SizedBox(height: 25),
                      Text(
                        'Stats',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(statsList.join(', ').capitalize2()),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: loading
          ? null
          : BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: goToPrevious,
                        icon: const Icon(Icons.arrow_back),
                        label: Text('#${allPokemons[previousIndex]['id']}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: goToNext,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text('#${allPokemons[nextIndex]['id']}'),
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
