import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/screens/places_details.dart';
import 'package:favorite_places/provider/favorite_places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlaces extends ConsumerWidget {
  const FavoritePlaces({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlaces = ref.watch(favoritePlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: favoritePlaces.favoritePlaces.isNotEmpty
          ? ListView.builder(
              itemCount: favoritePlaces.favoritePlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailScreen(
                          place: favoritePlaces.favoritePlaces[index],
                          
                        ),
                      ),
                    );
                  },
                  title: Text(favoritePlaces.favoritePlaces[index].title),
                );
              },
            )
          : const Center(
              child: Text(
                'No favorite places yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
    );
  }
}
