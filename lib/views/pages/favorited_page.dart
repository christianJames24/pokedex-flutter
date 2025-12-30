import 'package:application/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:application/data/string_extension.dart';
import 'details_page.dart';

class FavoritedPage extends StatelessWidget {
  const FavoritedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorited Pokemon',
          style: TextStyle(fontFamily: 'PokemonBW', fontSize: 28),
        ),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: favoritedPokemonsNotifier,
        builder: (context, favorites, child) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the star icon on any Pokemon to add it here',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pokemon = favorites[index];
              final typesList = (pokemon['types'] as String).split(',');

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/pokemon/${pokemon['id']}.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 40);
                    },
                  ),
                  title: Text(
                    (pokemon['name'] as String).capitalize2(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('#${pokemon['id']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: typesList.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Image.asset(
                          'assets/images/types/${type.trim()}.png',
                          height: 12,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox.shrink();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(pokemon: pokemon),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
