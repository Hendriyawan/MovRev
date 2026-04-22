import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';


const _similarNoValue = Object();
class MovieSimilarState {
  final List<Movie> movies;
  final List<Genre> genres;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const MovieSimilarState({
    this.movies = const <Movie>[],
    this.genres = const <Genre>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  MovieSimilarState copyWith({
    List<Movie>? movies,
    List<Genre>? genres,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? errorMessage = _similarNoValue,
  }) {
    return MovieSimilarState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: identical(errorMessage, _similarNoValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}