abstract class AllMovieEvent {}

class AllMovieFetch extends AllMovieEvent {
  final String type;
  final String? query;
  final int? movieId;
  final bool isRefresh;

  AllMovieFetch({
    required this.type,
    this.query,
    this.movieId,
    this.isRefresh = false,
  });
}

class AllMovieLoadMore extends AllMovieEvent {}
