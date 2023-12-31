import 'package:flutter/material.dart';

import '../db/favorites.dart';

class FavoritesNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  List<Favorite> get favs => _favs;

  FavoritesNotifier() {
    syncDb();
  }

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

  void syncDb() async {
    FavoritesDb.read().then(
      (val) => _favs
        ..clear()
        ..addAll(val),
    );
    notifyListeners();
  }

  void add(Favorite fav) async {
    favs.add(fav);
    await FavoritesDb.create(fav);
    syncDb();
  }

  void delete(int id) async {
    favs.removeWhere((fav) => fav.pokeId == id);
    await FavoritesDb.delete(id);
    syncDb();
  }
}

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': pokeId,
    };
  }
}

List<Favorite> favMock = [
  Favorite(pokeId: 1),
  Favorite(pokeId: 4),
  Favorite(pokeId: 7),
];
