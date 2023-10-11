import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.lightbulb),
          title: Text('Dark/Light Mode'),
        ),
      ],
    );
  }
}
