import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class TmdbService {
  static const _token = String.fromEnvironment('TMDB_TOKEN');
  static const _baseUrl = 'https://api.themoviedb.org/3';

  bool get isConfigured => _token.isNotEmpty;

  Future<List<Movie>> fetchTrending() async {
    if (!isConfigured) return const [];

    final response = await http.get(
      Uri.parse('$_baseUrl/trending/movie/week?language=es-PE'),
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo consultar TMDB');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['results'] as List<dynamic>)
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .where((movie) => movie.posterPath.isNotEmpty)
        .toList();
  }
}
