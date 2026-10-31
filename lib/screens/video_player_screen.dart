import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/movie.dart';
import '../theme/app_theme.dart';

class NovaVideoPlayerScreen extends StatefulWidget {
  const NovaVideoPlayerScreen({required this.movie, super.key});

  final Movie movie;

  @override
  State<NovaVideoPlayerScreen> createState() => _NovaVideoPlayerScreenState();
}

class _NovaVideoPlayerScreenState extends State<NovaVideoPlayerScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/nova_trailer.mp4');
    _controller.addListener(_refreshPlayer);
    _initialization = _controller.initialize().then((_) async {
      await _controller.setLooping(true);
      await _controller.play();
      if (mounted) setState(() {});
    });
  }

  void _refreshPlayer() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshPlayer)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) return _ErrorState(onRetry: _retry);
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: NovaColors.cyan),
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _showControls = !_showControls),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _showControls ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: _PlayerControls(
                        controller: _controller,
                        title: widget.movie.title,
                        onClose: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _retry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NovaVideoPlayerScreen(movie: widget.movie),
      ),
    );
  }
}

class _PlayerControls extends StatelessWidget {
  const _PlayerControls({
    required this.controller,
    required this.title,
    required this.onClose,
  });

  final VideoPlayerController controller;
  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    final duration = value.duration;
    final position = value.position > duration ? duration : value.position;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xAA000000), Colors.transparent, Color(0xCC000000)],
          stops: [0, .55, 1],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Cerrar reproductor',
                  onPressed: onClose,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Text(
                  'NOVA',
                  style: TextStyle(
                    color: NovaColors.cyan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton.filled(
            tooltip: value.isPlaying ? 'Pausar' : 'Reproducir',
            onPressed: value.isPlaying ? controller.pause : controller.play,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: .2),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            iconSize: 44,
            icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: NovaColors.violet,
                    bufferedColor: Colors.white38,
                    backgroundColor: Colors.white24,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  children: [
                    Text(
                      '${_time(position)} / ${_time(duration)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: value.volume == 0
                          ? 'Activar sonido'
                          : 'Silenciar',
                      onPressed: () =>
                          controller.setVolume(value.volume == 0 ? 1 : 0),
                      icon: Icon(
                        value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Retroceder 10 segundos',
                      onPressed: () => controller.seekTo(
                        position - const Duration(seconds: 10),
                      ),
                      icon: const Icon(Icons.replay_10),
                    ),
                    IconButton(
                      tooltip: 'Avanzar 10 segundos',
                      onPressed: () => controller.seekTo(
                        position + const Duration(seconds: 10),
                      ),
                      icon: const Icon(Icons.forward_10),
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

  static String _time(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: NovaColors.pink, size: 46),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar el video. Revisa tu conexión e inténtalo nuevamente.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
