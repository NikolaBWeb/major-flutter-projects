import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/places_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the theme from the context

    return places.isNotEmpty
        ? ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: FileImage(places[index].image),
                ),
                title: Text(
                  places[index].title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme
                        .onSurface, // Use onSurface for better contrast
                  ),
                ),
                subtitle: Text(
                  places[index].location.address,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaceDetailScreen(place: places[index]),
                    ),
                  );
                },
              );
            },
          )
        : const Center(
            child: Text(
              "No places found. Start adding some!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
  }
}
