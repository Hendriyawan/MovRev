import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/core/utils/movie_grouping_utils.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_popular_movies_use_case.dart';
import 'package:movrev/presentation/popular/popular_event.dart';
import 'package:movrev/presentation/popular/popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final GetGenresUseCase _genresUseCase;

  PopularBloc(this._getPopularMoviesUseCase, this._genresUseCase)
    : super(const PopularState()) {
    on<PopularInitial>((event, emit) => _fetchInitial(emit));
    on<PopularRefresh>((event, emit) => _fetchInitial(emit));
  }

  ///initial fetch popular movie from the API
  Future<void> _fetchInitial(Emitter<PopularState> emit) async {
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        movies: const <Movie>[],
        genreGroups: const [],
        errorMessage: null, // Reset error when loading starts
      ),
    );

    try {
      // 1. Fetch genres if they are not already loaded
      if (state.genres.isEmpty) {
        final genreResult = await _genresUseCase();
        if (!genreResult.hasError) {
          emit(state.copyWith(genres: genreResult.genres));
        }
      }

      // 2. Fetch first 10 pages in parallel (200 movies)
      const pagesToFetch = 10;
      final results = await Future.wait(
        List.generate(
          pagesToFetch,
          (index) => _getPopularMoviesUseCase(page: index + 1),
        ),
      );

      final List<Movie> allMovies = [];
      for (final result in results) {
        if (result.errorMessage != null) {
          // If any page fails, we still continue with others but log the error
          continue;
        }
        allMovies.addAll(result.movies);
      }

      // IF SUCCESSFUL
      final initialGroups = MovieGroupingUtils.groupByPopularGenre(
        allMovies,
        state.genres,
      );

      emit(
        state.copyWith(
          isLoading: false,
          movies: allMovies,
          genreGroups: initialGroups,
          hasMore: false, // Disable pagination
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          hasMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

