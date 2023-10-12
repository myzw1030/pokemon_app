import 'package:flutter/material.dart';
import 'package:pokemon_app/const/pokeapi.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/models/favorite.dart';
import 'package:pokemon_app/poke_list_item.dart';
import 'package:provider/provider.dart';

class PokeList extends StatefulWidget {
  const PokeList({super.key});

  @override
  State<PokeList> createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  bool isFavoriteMode = false;
  int _currentPage = 1;

  // 表示個数
  int itemCount(int favsCount, int page) {
    int ret = page * pageSize;

    if (isFavoriteMode && ret > favsCount) {
      ret = favsCount;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(List<Favorite> favs, int index) {
    int ret = index + 1;
    if (isFavoriteMode && index < favs.length) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  bool isLastPage(int favsCount, int page) {
    if (isFavoriteMode) {
      if (_currentPage * pageSize < favsCount) {
        return false;
      }
      return true;
    } else {
      if (_currentPage * pageSize < pokeMaxId) {
        return false;
      }
      return true;
    }
  }

  void changeFavMode(bool currentMode) {
    setState(() {
      isFavoriteMode = !currentMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          Container(
            height: 24,
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.auto_awesome_outlined),
              onPressed: () async {
                var ret = await showModalBottomSheet<bool>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return ViewModelBottomSheet(
                      favMode: isFavoriteMode,
                      changeFavMode: changeFavMode,
                    );
                  },
                );
                // if (ret != null && ret) {
                //   changeModel(isFavoriteMode);
                // }
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if (itemCount(favs.favs.length, _currentPage) == 0) {
                  return const Text('no date');
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                    itemBuilder: (context, index) {
                      if (index == itemCount(favs.favs.length, _currentPage)) {
                        return OutlinedButton(
                          onPressed: isLastPage(favs.favs.length, _currentPage)
                              ? null
                              : () => {
                                    setState(
                                      () {
                                        _currentPage++;
                                      },
                                    ),
                                  },
                          child: const Text('more'),
                        );
                      } else {
                        return PokeListItem(
                          poke: pokes.byId(itemId(favs.favs, index)),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ViewModelBottomSheet extends StatelessWidget {
  const ViewModelBottomSheet({
    Key? key,
    required this.favMode,
    required this.changeFavMode,
  }) : super(key: key);
  final bool favMode;
  final Function(bool) changeFavMode;

  String mainText(bool fav) {
    if (fav) {
      return 'お気に入りのポケモンが表示されています';
    } else {
      return 'すべてのポケモンが表示されています';
    }
  }

  String menuSubtitle(bool fav) {
    if (fav) {
      return 'すべてのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Text(
                mainText(favMode),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                menuSubtitle(favMode),
              ),
              onTap: () {
                changeFavMode(favMode);
                Navigator.pop(context, true);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
