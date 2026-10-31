import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import '../widgets/network_art.dart';
import 'details_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) {
        final movies = repository.watchlist;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Mi lista',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text('Lista ordenada por fecha'),
                              ),
                            ),
                        icon: const Icon(Icons.tune),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: movies.isEmpty
                        ? const _EmptyList()
                        : ListView.separated(
                            itemCount: movies.length,
                            separatorBuilder: (_, _) =>
                                const Divider(color: NovaColors.border),
                            itemBuilder: (context, index) => _WatchlistTile(
                              movie: movies[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsScreen(movie: movies[index]),
                                ),
                              ),
                              onDelete: () =>
                                  repository.removeFromWatchlist(movies[index]),
                            ),
                          ),
                  ),
                  if (movies.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: NovaColors.violet,
                            size: 38,
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Tu lista está en constante crecimiento',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Guarda las películas y series que más te gusten.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: NovaColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WatchlistTile extends StatelessWidget {
  const _WatchlistTile({
    required this.movie,
    required this.onTap,
    required this.onDelete,
  });

  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: SizedBox(
        width: 58,
        height: 76,
        child: NetworkArt(url: movie.posterUrl, borderRadius: 8),
      ),
      title: Text(
        movie.title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        'Ciencia ficción  •  2h 10m\n★ ${movie.voteAverage.toStringAsFixed(1)}',
        style: const TextStyle(fontSize: 10, color: NovaColors.textMuted),
      ),
      trailing: IconButton(
        onPressed: onDelete,
        style: IconButton.styleFrom(backgroundColor: NovaColors.card),
        icon: const Icon(Icons.delete_outline, size: 20),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: NovaColors.cyan),
          SizedBox(height: 12),
          Text(
            'Tu lista está vacía',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            'Agrega películas para verlas más tarde.',
            style: TextStyle(color: NovaColors.textMuted),
          ),
        ],
      ),
    );
  }
}
