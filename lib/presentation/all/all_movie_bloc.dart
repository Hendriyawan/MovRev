import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/search_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_top_rated_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_movies_by_genre_use_case.dart';
import 'all_movie_event.dart';
import 'all_movie_state.dart';

class AllMovieBloc extends Bloc<AllMovieEvent, AllMovieState> {
  final GetTopRatedMoviesUseCase getTopRatedMoviesUseCase;
  final GetSimilarMoviesUseCase getSimilarMoviesUseCase;
  final SearchMoviesUseCase searchMoviesUseCase;
  final GetGenresUseCase getGenresUseCase;
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;

  AllMovieBloc({
    required this.getTopRatedMoviesUseCase,
    required this.getSimilarMoviesUseCase,
    required this.searchMoviesUseCase,
    required this.getGenresUseCase,
    required this.getMoviesByGenreUseCase,
  }) : super(AllMovieState()) {
    on<AllMovieFetch>(_onFetch);
    on<AllMovieLoadMore>(_onLoadMore);
  }

  Future<void> _onFetch(
    AllMovieFetch event,
    Emitter<AllMovieState> emit,
  ) async {
    if (event.isRefresh) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    } else {
      emit(AllMovieState(
        isLoading: true,
        type: event.type,
        query: event.query,
        movieId: event.movieId,
      ));
    }

    // Fetch genres if not already fetched
    if (state.genres.isEmpty) {
      final genreResult = await getGenresUseCase();
      emit(state.copyWith(genres: genreResult.genres));
    }

    final MovieResult result;
    switch (event.type) {
      case 'top_rated':
        result = await getTopRatedMoviesUseCase(page: 1);
        break;
      case 'similar':
        result = await getSimilarMoviesUseCase(
          movieId: event.movieId ?? 0,
          page: 1,
        );
        break;
      case 'search':
        if (event.query == null || event.query!.isEmpty) {
          emit(state.copyWith(isLoading: false, movies: []));
          return;
        }
        result = await searchMoviesUseCase(query: event.query!, page: 1);
        break;
      case 'movie_by_genre':
        result = await getMoviesByGenreUseCase(
          genreId: event.movieId ?? 0,
          page: 1,
        );
        break;
      default:
        emit(state.copyWith(isLoading: false, errorMessage: 'Invalid type'));
        return;
    }

    if (result.errorMessage != null) {
      emit(state.copyWith(isLoading: false, errorMessage: result.errorMessage));
    } else {
      emit(state.copyWith(
        isLoading: false,
        movies: result.movies,
        currentPage: 1,
        totalPages: result.totalPages,
      ));
    }
  }

  Future<void> _onLoadMore(
    AllMovieLoadMore event,
    Emitter<AllMovieState> emit,
  ) async {
    if (state.isLoadingMore || state.currentPage >= state.totalPages) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final MovieResult result;

    switch (state.type) {
      case 'top_rated':
        result = await getTopRatedMoviesUseCase(page: nextPage);
        break;
      case 'similar':
        result = await getSimilarMoviesUseCase(
          movieId: state.movieId ?? 0,
          page: nextPage,
        );
        break;
      case 'search':
        result = await searchMoviesUseCase(query: state.query ?? '', page: nextPage);
        break;
      case 'movie_by_genre':
        result = await getMoviesByGenreUseCase(
          genreId: state.movieId ?? 0,
          page: nextPage,
        );
        break;
      default:
        emit(state.copyWith(isLoadingMore: false));
        return;
    }

    if (result.errorMessage != null) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: result.errorMessage));
    } else {
      emit(state.copyWith(
        isLoadingMore: false,
        movies: [...state.movies, ...result.movies],
        currentPage: nextPage,
      ));
    }
  }
}

