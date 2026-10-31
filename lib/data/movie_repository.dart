import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieRepository extends ChangeNotifier {
  MovieRepository._();

  static final MovieRepository instance = MovieRepository._();

  final TmdbService _service = TmdbService();
  final Set<int> _watchlistIds = {11, 13, 14, 18, 20};

  bool isLoading = false;
  bool notificationsEnabled = true;
  bool darkMode = true;
  String userName = 'Piero Huaytalla';
  String email = 'piero@nova.com';

  List<Movie> movies = _fallbackMovies;

  List<Movie> get watchlist =>
      movies.where((movie) => _watchlistIds.contains(movie.id)).toList();

  bool isSaved(Movie movie) => _watchlistIds.contains(movie.id);

  Future<void> loadMovies() async {
    isLoading = true;
    notifyListeners();
    try {
      final remote = await _service.fetchTrending();
      if (remote.isNotEmpty) {
        movies = remote;
        _watchlistIds
          ..clear()
          ..addAll(remote.take(5).map((movie) => movie.id));
      }
    } catch (_) {
      movies = _fallbackMovies;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSaved(Movie movie) {
    if (!_watchlistIds.add(movie.id)) _watchlistIds.remove(movie.id);
    notifyListeners();
  }

  void removeFromWatchlist(Movie movie) {
    _watchlistIds.remove(movie.id);
    notifyListeners();
  }

  void setNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void updateProfile(String name, String newEmail) {
    userName = name;
    email = newEmail;
    notifyListeners();
  }
}

const _fallbackMovies = <Movie>[
  Movie(
    id: 11,
    title: 'Horizonte Infinito',
    overview: 'Cuando el universo se expande, los límites desaparecen. Una tripulación deberá proteger el último refugio de la humanidad.',
    posterPath: '/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg',
    backdropPath: '/s3TBrRGB1iav7gFOCNx3H31MoES.jpg',
    releaseDate: '2024-06-14',
    voteAverage: 8.7,
    genreIds: [878, 12],
  ),
  Movie(
    id: 12,
    title: 'El Último Guardián',
    overview: 'Un héroe inesperado deberá proteger un antiguo secreto que podría cambiar el destino del mundo.',
    posterPath: '/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
    backdropPath: '/xJHokMbljvjADYdit5fK5VQsXEG.jpg',
    releaseDate: '2024-03-21',
    voteAverage: 8.2,
    genreIds: [28, 12],
  ),
  Movie(
    id: 13,
    title: 'Reino de Sombras',
    overview: 'Una aventura épica entre mundos, secretos y antiguas alianzas.',
    posterPath: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    backdropPath: '/n5A7brJCjejceZmHyujwUTVgQNC.jpg',
    releaseDate: '2023-11-05',
    voteAverage: 8.4,
    genreIds: [14, 12],
  ),
  Movie(
    id: 14,
    title: 'Ciudad Nocturna',
    overview:
        'En una ciudad sin amanecer, un detective descubre una conspiración.',
    posterPath: '/aQvJ5WPzZgYVDrxLX4R6cLJCEaQ.jpg',
    backdropPath: '/zGLHX92Gk96O1DJvLil7ObJTbaL.jpg',
    releaseDate: '2023-09-19',
    voteAverage: 7.9,
    genreIds: [53, 80],
  ),
  Movie(
    id: 15,
    title: 'Fuego Eterno',
    overview: 'Una fuerza ancestral despierta y amenaza con consumirlo todo.',
    posterPath: '/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
    backdropPath: '/8rpDcsfLJypbO6vREc0547VKqEv.jpg',
    releaseDate: '2024-01-08',
    voteAverage: 8.1,
    genreIds: [28, 14],
  ),
  Movie(
    id: 16,
    title: 'Código Estelar',
    overview: 'El mensaje de una estrella distante podría salvar a la Tierra.',
    posterPath: '/hA2ple9q4qnwxp3hKVNhroipsir.jpg',
    backdropPath: '/yF1eOkaYvwiORauRCPWznV9xVvi.jpg',
    releaseDate: '2024-04-13',
    voteAverage: 7.8,
    genreIds: [878],
  ),
  Movie(
    id: 17,
    title: 'Viaje al Mañana',
    overview: 'Un viaje extraordinario hacia un futuro que nadie imaginó.',
    posterPath: '/vBZ0qvaRxqEhZwl6LWmruJqWE8Z.jpg',
    backdropPath: '/tRS6jvPM9qPrrnx2KRp3ew96Yot.jpg',
    releaseDate: '2024-07-26',
    voteAverage: 8.0,
    genreIds: [12, 878],
  ),
  Movie(
    id: 18,
    title: 'Secretos del Océano',
    overview: 'Una expedición descubre vida y misterios bajo el océano.',
    posterPath: '/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
    backdropPath: '/9ZlGiEKmcYrrxmiQEJDhjeT2kEW.jpg',
    releaseDate: '2024-02-16',
    voteAverage: 7.7,
    genreIds: [99, 12],
  ),
  Movie(
    id: 19,
    title: 'Mundos de Colores',
    overview: 'Una familia descubre que la imaginación puede abrir universos.',
    posterPath: '/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg',
    backdropPath: '/j29ekbcLpBvxnGk6LjdTc2EI5SA.jpg',
    releaseDate: '2023-12-10',
    voteAverage: 7.6,
    genreIds: [16, 35],
  ),
  Movie(
    id: 20,
    title: 'Límite Final',
    overview: 'La última misión pondrá a prueba a los mejores exploradores.',
    posterPath: '/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg',
    backdropPath: '/i7UCf0ysjbYYaqcSKUox9BJz4Kp.jpg',
    releaseDate: '2024-08-02',
    voteAverage: 8.3,
    genreIds: [28, 878],
  ),
];
