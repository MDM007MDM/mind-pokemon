import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({Key? key, required this.pokemonListItem})
      : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? pokemonDetails;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemonDetails = jsonDecode(response.body);
      });
    } else {
      print('Failed to load Pokemon details');
    }
  }

  String getPokemonImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name),
        backgroundColor: Colors.redAccent, // A bit of color
      ),
      body: pokemonDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center everything
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light grey background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      getPokemonImageUrl(pokemonDetails!['id']),
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    pokemonDetails!['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('ID: ${pokemonDetails!['id']}'),
                  const SizedBox(height: 8),
                  // Types with Chips, but more subtly
                  Wrap(
                    spacing: 8.0,
                    children: (pokemonDetails!['types'] as List)
                        .map<Widget>((typeData) => Chip(
                              label: Text(typeData['type']['name']),
                              backgroundColor:
                                  _getTypeColor(typeData['type']['name'])
                                      .withOpacity(0.8), // Lighter colors
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Text("Height: ${pokemonDetails!['height'] / 10} m"),
                  const SizedBox(height: 8),
                  Text("Weight: ${pokemonDetails!['weight'] / 10} kg"),
                  const SizedBox(height: 16),

                  // Stats with simple labels and values
                  const Text('Stats',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Table(
                    // Use a Table for better alignment
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Wider column for stat names
                      1: FlexColumnWidth(1),
                    },
                    children: (pokemonDetails!['stats'] as List)
                        .map<TableRow>((statData) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              statData['stat']['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(statData['base_stat'].toString()),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper function to get type colors (add more as needed)
  Color _getTypeColor(String type) {
    switch (type) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'bug':
        return Colors.lightGreen;
      case 'flying':
        return Colors.lightBlue;
      case 'normal':
        return Colors.grey;
      case 'psychic':
        return Colors.pink;
      case 'fighting':
        return Colors.orange;
      case 'ghost':
        return Colors.deepPurple;
      case 'ice':
        return Colors.lightBlueAccent;
      case 'dragon':
        return Colors.indigo;
      case 'steel':
        return Colors.blueGrey;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pinkAccent;

      default:
        return Colors.grey;
    }
  }
}
