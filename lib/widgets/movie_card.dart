import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../theme/app_theme.dart';
import 'network_art.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    required this.onTap,
    this.width = 112,
    super.key,
  });

  final Movie movie;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: NetworkArt(url: movie.posterUrl)),
            const SizedBox(height: 7),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              movie.year,
              style: const TextStyle(color: NovaColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
