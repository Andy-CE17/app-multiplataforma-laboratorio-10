import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/movie_card.dart';
import '../widgets/network_art.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) {
        final movies = _query.isEmpty
            ? repository.movies
            : repository.movies
                  .where(
                    (movie) => movie.title.toLowerCase().contains(
                      _query.toLowerCase(),
                    ),
                  )
                  .toList();
        final featured = repository.movies.first;
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: repository.loadMovies,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                          'assets/images/piero_avatar.png',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, ${repository.userName.split(' ').first} 👑',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              '¿Qué quieres ver hoy?',
                              style: TextStyle(
                                color: NovaColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No tienes notificaciones nuevas',
                                ),
                              ),
                            ),
                        icon: const Icon(Icons.notifications_none),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar películas, series...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? const Icon(Icons.tune)
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                  if (_query.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _SectionTitle(title: 'Resultados (${movies.length})'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 205,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) => MovieCard(
                          movie: movies[index],
                          onTap: () => _openDetails(movies[index]),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    _FeaturedMovie(
                      movie: featured,
                      isSaved: repository.isSaved(featured),
                      onPlay: () => _playMessage(featured),
                      onList: () => repository.toggleSaved(featured),
                    ),
                    const SizedBox(height: 20),
                    _MovieRow(
                      title: 'Tendencias',
                      movies: repository.movies.take(6).toList(),
                      onTap: _openDetails,
                    ),
                    const SizedBox(height: 18),
                    _MovieRow(
                      title: 'Recomendadas para ti',
                      movies: repository.movies.reversed.take(6).toList(),
                      onTap: _openDetails,
                    ),
                    const SizedBox(height: 18),
                    _ContinueWatching(movie: repository.movies[1]),
                  ],
                ],
              ),
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

  void _playMessage(Movie movie) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Reproduciendo ${movie.title}')));
  }
}

class _FeaturedMovie extends StatelessWidget {
  const _FeaturedMovie({
    required this.movie,
    required this.isSaved,
    required this.onPlay,
    required this.onList,
  });

  final Movie movie;
  final bool isSaved;
  final VoidCallback onPlay;
  final VoidCallback onList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkArt(url: movie.backdropUrl, borderRadius: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xEE020A19)],
                stops: [.3, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: .95,
                    shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, height: 1.35),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const _Tag(label: 'Ciencia ficción'),
                    _Tag(label: movie.year),
                    const _Tag(label: 'PG-13'),
                    _Tag(label: '★ ${movie.voteAverage.toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'Reproducir',
                        icon: Icons.play_arrow,
                        onTap: onPlay,
                        height: 42,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onList,
                      icon: Icon(isSaved ? Icons.check : Icons.add, size: 17),
                      label: Text(isSaved ? 'Guardada' : 'Mi lista'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(105, 42),
                        side: const BorderSide(color: NovaColors.border),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xBB10203B),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: const TextStyle(fontSize: 8)),
    );
  }
}

class _MovieRow extends StatelessWidget {
  const _MovieRow({
    required this.title,
    required this.movies,
    required this.onTap,
  });
  final String title;
  final List<Movie> movies;
  final ValueChanged<Movie> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(title: title),
        const SizedBox(height: 10),
        SizedBox(
          height: 205,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) => MovieCard(
              movie: movies[index],
              onTap: () => onTap(movies[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const Text(
          'Ver más  ›',
          style: TextStyle(color: NovaColors.cyan, fontSize: 11),
        ),
      ],
    );
  }
}

class _ContinueWatching extends StatelessWidget {
  const _ContinueWatching({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(title: 'Continuar viendo'),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkArt(url: movie.backdropUrl),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xEE020A19)],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 7),
                    const LinearProgressIndicator(
                      value: .62,
                      backgroundColor: Colors.white24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
