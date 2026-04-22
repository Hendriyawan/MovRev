import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';

class AllMovieState {
  final List<Movie> movies;
  final List<Genre> genres;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final String type;
  final String? query;
  final int? movieId;

  AllMovieState({
    this.movies = const [],
    this.genres = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.type = '',
    this.query,
    this.movieId,
  });

  AllMovieState copyWith({
    List<Movie>? movies,
    List<Genre>? genres,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    String? type,
    String? query,
    int? movieId,
  }) {
    return AllMovieState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      type: type ?? this.type,
      query: query ?? this.query,
      movieId: movieId ?? this.movieId,
    );
  }
}
