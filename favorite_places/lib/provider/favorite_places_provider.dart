import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FavoritePlacesProvider extends ChangeNotifier {
  final List<Place> _favoritePlaces = [];

  List<Place> get favoritePlaces => _favoritePlaces;

  void addFavoritePlace(Place place) {
    _favoritePlaces.add(place);
    notifyListeners();
  }

  void removeFavoritePlace(Place place) {
    _favoritePlaces.remove(place);
    notifyListeners();
  }
}

final favoritePlacesProvider = ChangeNotifierProvider((ref) => FavoritePlacesProvider());


  
