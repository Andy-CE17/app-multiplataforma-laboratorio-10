import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/network_art.dart';
import 'details_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedGenre = 28;

  static const genres = <Map<String, dynamic>>[
    {'id': 28, 'name': 'Acción', 'emoji': '🔥'},
    {'id': 35, 'name': 'Comedia', 'emoji': '😊'},
    {'id': 53, 'name': 'Terror', 'emoji': '🩸'},
    {'id': 16, 'name': 'Animación', 'emoji': '💧'},
    {'id': 878, 'name': 'Ciencia ficción', 'emoji': '◉'},
    {'id': 12, 'name': 'Aventura', 'emoji': '★'},
  ];

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) {
        final filtered = repository.movies.where((movie) {
          final matchesGenre =
              movie.genreIds.contains(_selectedGenre) ||
              movie.genreIds.isEmpty ||
              repository.movies.length <= 10;
          return matchesGenre;
        }).toList();
        final list = filtered.isEmpty ? repository.movies : filtered;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Categorías',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showSearch(
                        context: context,
                        delegate: _MovieSearchDelegate(repository.movies),
                      ),
                      icon: const Icon(Icons.search, size: 27),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: genres.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.55,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    final movie =
                        repository.movies[index % repository.movies.length];
                    final selected = genre['id'] == _selectedGenre;
                    return InkWell(
                      onTap: () =>
                          setState(() => _selectedGenre = genre['id'] as int),
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          NetworkArt(url: movie.backdropUrl),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: selected
                                    ? NovaColors.cyan
                                    : Colors.transparent,
                                width: 2,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xEE020A19)],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 9,
                            child: Text(
                              '${genre['emoji']}  ${genre['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Películas de ${genres.firstWhere((genre) => genre['id'] == _selectedGenre)['name']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text(
                      'Ver más  ›',
                      style: TextStyle(color: NovaColors.cyan, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length.clamp(0, 6),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: .56,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => MovieCard(
                    movie: list[index],
                    width: 100,
                    onTap: () => _openDetails(list[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(movie: movie)),
    );
  }
}

class _MovieSearchDelegate extends SearchDelegate<Movie?> {
  _MovieSearchDelegate(this.movies);
  final List<Movie> movies;

  @override
  String get searchFieldLabel => 'Buscar película...';

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final results = movies
        .where(
          (movie) => movie.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        leading: SizedBox(
          width: 45,
          child: NetworkArt(url: results[index].posterUrl, borderRadius: 6),
        ),
        title: Text(results[index].title),
        subtitle: Text(results[index].year),
        onTap: () {
          close(context, results[index]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(movie: results[index]),
            ),
          );
        },
      ),
    );
  }
}
