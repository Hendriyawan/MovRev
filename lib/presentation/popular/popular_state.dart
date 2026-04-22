import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';

const _popularNovalue = Object();
class PopularState {

  final List<Movie> movies;
  final List<Genre> genres;
  final List<Map<String, dynamic>> genreGroups;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const PopularState({
    this.movies = const <Movie>[],
    this.genres = const <Genre>[],
    this.genreGroups = const <Map<String, dynamic>>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  PopularState copyWith({
    List<Movie>? movies,
    List<Genre>? genres,
    List<Map<String, dynamic>>? genreGroups,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? errorMessage = _popularNovalue,
  }) {
    return PopularState(
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      genreGroups: genreGroups ?? this.genreGroups,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage:
          identical(errorMessage, _popularNovalue)
              ? this.errorMessage
              : errorMessage as String?,
    );
  }
}