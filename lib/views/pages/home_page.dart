import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:application/data/string_extension.dart';

enum SortOption {
  idAsc('ID: Low to High'),
  idDesc('ID: High to Low'),
  nameAsc('Name: A-Z'),
  nameDesc('Name: Z-A');

  const SortOption(this.label);
  final String label;
}

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

  static List _decodeJson(String response) {
    return json.decode(response);
  }

  Future<void> loadPokemons() async {
    final response = await rootBundle.loadString(
      'assets/datasets/pokemon_data.json',
    );

    final List data = await compute(_decodeJson, response);

    final List unova = data.where((p) {
      final int id = int.tryParse(p['id'].toString()) ?? 0;
      return id >= 494 && id <= 649;
    }).toList();

    if (mounted) {
      setState(() {
        allPokemons = unova;
        filteredPokemons = _sortPokemons(unova);
        loading = false;
      });
    }
  }

  List _sortPokemons(List pokemons) {
    final sorted = List.from(pokemons);

    switch (currentSort) {
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

  void searchPokemon(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final q = query.toLowerCase();

      setState(() {
        final filtered = allPokemons.where((p) {
          final name = p['name'].toString().toLowerCase();
          final id = p['id'].toString();

          return name.contains(q) || id.contains(q);
        }).toList();

        filteredPokemons = _sortPokemons(filtered);
      });
    });
  }

  void changeSortOption(SortOption? option) {
    if (option == null || option == currentSort) return;

    setState(() {
      currentSort = option;
      filteredPokemons = _sortPokemons(filteredPokemons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unova Pokedex'),
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

                return Column(
                  key: ValueKey('pokemon_$pokemonId'),
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint('Tapped ${p['name']}');
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
                                    Text(
                                      (p['types'] as String).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
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
