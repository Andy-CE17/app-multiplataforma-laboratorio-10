class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final List<int> genreIds;

  String get year =>
      releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '2026';

  String get posterUrl => posterPath.startsWith('http')
      ? posterPath
      : 'https://image.tmdb.org/t/p/w500$posterPath';

  String get backdropUrl => backdropPath.startsWith('http')
      ? backdropPath
      : 'https://image.tmdb.org/t/p/w1280$backdropPath';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? 'Sin título') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
      backdropPath: (json['backdrop_path'] ?? '') as String,
      releaseDate:
          (json['release_date'] ?? json['first_air_date'] ?? '') as String,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? const <int>[]),
    );
  }
}
