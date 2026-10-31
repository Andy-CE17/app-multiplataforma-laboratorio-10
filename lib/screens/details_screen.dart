import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/movie_card.dart';
import '../widgets/network_art.dart';
import 'video_player_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              backgroundColor: NovaColors.background,
              actions: [
                IconButton(
                  onPressed: () => repository.toggleSaved(movie),
                  icon: Icon(
                    repository.isSaved(movie)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: NovaColors.pink,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetworkArt(url: movie.backdropUrl, borderRadius: 0),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0x55020A19),
                            NovaColors.background,
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () => _playMovie(context),
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black45,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.play_arrow, size: 38),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          height: .95,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Text(movie.year),
                      const Text('  •  2h 15m  •  '),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: NovaColors.textMuted),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'PG-13',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      const Text('  •  Acción, Aventura'),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Text(
                    movie.overview.isEmpty
                        ? 'Una historia extraordinaria en los límites del universo.'
                        : movie.overview,
                    style: const TextStyle(
                      color: Color(0xFFD1D8E5),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GradientButton(
                    label: 'Reproducir',
                    icon: Icons.play_arrow,
                    onTap: () => _playMovie(context),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => repository.toggleSaved(movie),
                    icon: Icon(
                      repository.isSaved(movie) ? Icons.check : Icons.add,
                    ),
                    label: Text(
                      repository.isSaved(movie)
                          ? 'Agregada a mi lista'
                          : 'Agregar a mi lista',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: NovaColors.cyan),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _TitleRow(title: 'Reparto'),
                  const SizedBox(height: 12),
                  const _CastRow(),
                  const SizedBox(height: 24),
                  const _TitleRow(title: 'Similares'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 205,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: repository.movies.take(5).length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final similar = repository.movies[index];
                        return MovieCard(
                          movie: similar,
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(movie: similar),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playMovie(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovaVideoPlayerScreen(movie: movie),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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

class _CastRow extends StatelessWidget {
  const _CastRow();

  static const cast = [
    ('Luis Torres', 'Protagonista', Icons.person),
    ('Valeria Ríos', 'Protagonista', Icons.person_2),
    ('Diego Luna', 'Antagonista', Icons.person_3),
    ('Sofía Mena', 'Secundario', Icons.person_4),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) => SizedBox(
          width: 68,
          child: Column(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: NovaColors.card,
                child: Icon(cast[index].$3, size: 30),
              ),
              const SizedBox(height: 5),
              Text(
                cast[index].$1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              ),
              Text(
                cast[index].$2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 7,
                  color: NovaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
