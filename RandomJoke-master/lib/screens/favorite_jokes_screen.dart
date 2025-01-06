import 'package:flutter/material.dart';
import '../services/api_services.dart';

class FavoriteJokesScreen extends StatelessWidget {
  const FavoriteJokesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jokes'),
      ),
      body: ListView.builder(
        itemCount: ApiService.favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = ApiService.favoriteJokes[index];
          return ListTile(
            title: Text(joke['setup']!),
            subtitle: Text(joke['punchline']!),
          );
        },
      ),
    );
  }
}
