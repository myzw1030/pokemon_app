import 'package:flutter/material.dart';

class FavoritesNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  List<Favorite> get favs => _favs;

  void toggle(Favorite fav) {
    if (isExist(fav.pokeId)) {
      delete(fav.pokeId);
    } else {
      add(fav);
    }
  }

  bool isExist(int id) {
    if (_favs.indexWhere((fav) => fav.pokeId == id) < 0) {
      return false;
    }
    return true;
  }

  void add(Favorite fav) {
    favs.add(fav);
    notifyListeners();
  }

  void delete(int id) {
    favs.removeWhere((fav) => fav.pokeId == id);
    notifyListeners();
  }
}

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });
}

List<Favorite> favMock = [
  Favorite(pokeId: 1),
  Favorite(pokeId: 4),
  Favorite(pokeId: 7),
];
