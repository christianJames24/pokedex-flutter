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

  TextEditingController controller = TextEditingController();
  bool? isChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? menuItem = 'e1';

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

  int get previousIndex =>
      (currentIndex - 1 + allPokemons.length) % allPokemons.length;
  int get nextIndex => (currentIndex + 1) % allPokemons.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: const [CloseButton()],
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
                      Image.asset(
                        'assets/images/sprites/${currentPokemon['id']}.gif',
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          );
                        },
                      ),
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
