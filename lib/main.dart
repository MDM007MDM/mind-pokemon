import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/views/pokemonlist_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Pokemon App'),
          backgroundColor: const Color.fromARGB(255, 244, 213, 15),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        body: const PokemonList(),
      ),
    );
  }
}
