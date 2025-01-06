import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'package:randomjoke/models/joke.dart';

class JokeListScreen extends StatelessWidget {
  final String jokeType;

  const JokeListScreen({Key? key, required this.jokeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: $jokeType'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: ApiService.fetchJokesByType(jokeType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jokes found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                return ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    color: Colors.red,
                    onPressed: () {
                      ApiService.favoriteJokes.add({
                        'setup': joke.setup,
                        'punchline': joke.punchline,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joke added to favorites!')),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
