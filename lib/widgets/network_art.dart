import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NetworkArt extends StatelessWidget {
  const NetworkArt({
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: NovaColors.card,
        child: url.isEmpty
            ? const _Fallback()
            : Image.network(
                url,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                errorBuilder: (context, error, stackTrace) => const _Fallback(),
              ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.movie_outlined, color: NovaColors.cyan, size: 42),
    );
  }
}
