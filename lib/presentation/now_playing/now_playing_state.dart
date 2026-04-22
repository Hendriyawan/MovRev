import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';

const _nowPlayingNoValue = Object();

class NowPlayingState {
  final List<Movie> movies;
  final List<Genre> genres;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const NowPlayingState({
    this.movies = const <Movie>[],
    this.genres = const <Genre>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  NowPlayingState copyWith({
    List<Movie>? movies,
    List<Genre>? genres,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? errorMessage = _nowPlayingNoValue,
  }) {
    return NowPlayingState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: identical(errorMessage, _nowPlayingNoValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
