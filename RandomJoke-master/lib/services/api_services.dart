import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke.dart';

class ApiService {
  static const String baseUrl = "https://official-joke-api.appspot.com";
  static List<Map<String, String>> favoriteJokes = [];

  static Future<List<String>> fetchJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load joke types");
    }
  }

  static Future<List<Joke>> fetchJokesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));
    if (response.statusCode == 200) {
      List<dynamic> jokesJson = json.decode(response.body);
      return jokesJson.map((json) => Joke.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load jokes");
    }
  }

  static Future<Joke> fetchRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load random joke");
    }
  }
}
