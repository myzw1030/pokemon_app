import 'package:flutter/material.dart';
import 'package:pokemon_app/poke_list_item.dart';

class PokeList extends StatelessWidget {
  const PokeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      itemCount: 1000,
      itemBuilder: (BuildContext context, int index) {
        return const PokeListItem();
      },
    );
  }
}
