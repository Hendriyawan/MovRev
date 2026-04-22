import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';

const _topRatedNoValue = Object();

class TopRatedState {
  final List<Movie> movies;
  final List<Genre> genres;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const TopRatedState({
    this.movies = const <Movie>[],
    this.genres = const <Genre>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  TopRatedState copyWith({
    List<Movie>? movies,
    List<Genre>? genres,
    bool? isLoading,
  bool? isLoadingMore,
    bool? hasMore,
    Object? errorMessage = _topRatedNoValue,
  }) {
    return TopRatedState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: identical(errorMessage, _topRatedNoValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
