import 'package:flutter/material.dart';
import 'dart:async';
import 'package:application/data/string_extension.dart';
import 'package:application/data/pokemon.dart';
import 'package:application/views/pages/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List allPokemons = [];
  List filteredPokemons = [];
  bool loading = true;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  SortOption currentSort = SortOption.idAsc;

  @override
  void initState() {
    super.initState();
    loadPokemons();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadPokemons() async {
    final List data = await PokemonData.loadAllPokemons();
    final List unova = PokemonData.filterUnovaPokemons(data);

    if (mounted) {
      setState(() {
        allPokemons = unova;
        filteredPokemons = PokemonData.sortPokemons(unova, currentSort);
        loading = false;
      });
    }
  }

  void searchPokemon(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        final filtered = PokemonData.searchPokemons(allPokemons, query);
        filteredPokemons = PokemonData.sortPokemons(filtered, currentSort);
      });
    });
  }

  void changeSortOption(SortOption? option) {
    if (option == null || option == currentSort) return;

    setState(() {
      currentSort = option;
      filteredPokemons = PokemonData.sortPokemons(
        filteredPokemons,
        currentSort,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unova Pokedex',
          style: TextStyle(fontFamily: 'PokemonBW', fontSize: 28),
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: changeSortOption,
            itemBuilder: (context) => SortOption.values.map((option) {
              return PopupMenuItem<SortOption>(
                value: option,
                child: Row(
                  children: [
                    if (option == currentSort)
                      const Icon(Icons.check, size: 20)
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 12),
                    Text(option.label),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              key: const ValueKey('search_field'),
              controller: _searchController,
              onChanged: searchPokemon,
              decoration: InputDecoration(
                hintText: 'Search name or ID',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(
              key: ValueKey('loading'),
              child: CircularProgressIndicator(),
            )
          : filteredPokemons.isEmpty
          ? const Center(
              key: ValueKey('empty'),
              child: Text('No Pokémon found'),
            )
          : ListView.builder(
              key: ValueKey('list_${filteredPokemons.length}_$currentSort'),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: filteredPokemons.length,
              itemBuilder: (context, index) {
                final p = filteredPokemons[index];
                final pokemonId = p['id']?.toString() ?? index.toString();
                final typesList = (p['types'] as String).split(',');

                return Column(
                  key: ValueKey('pokemon_$pokemonId'),
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(pokemon: p),
                            ),
                          );
                        },
                        splashColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.2),
                        highlightColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: Image.asset(
                                  'assets/images/sprites/$pokemonId.gif',
                                  fit: BoxFit.contain,
                                  excludeFromSemantics: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (p['name'] as String).capitalize2(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '#${p['id'] ?? '?'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    // Text(
                                    //   (p['types'] as String).toUpperCase(),
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.grey.shade600,
                                    //   ),
                                    // ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: typesList.map((type) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Image.asset(
                                            'assets/images/types/${type.trim()}.png',
                                            fit: BoxFit.contain,
                                            excludeFromSemantics: true,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.image_not_supported,
                                                    size: 48,
                                                  );
                                                },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (index < filteredPokemons.length - 1)
                      const Divider(height: 1, thickness: 1),
                  ],
                );
              },
            ),
    );
  }
}
