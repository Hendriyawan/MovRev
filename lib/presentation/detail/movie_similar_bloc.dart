import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movrev/presentation/detail/movie_similar_event.dart';
import 'package:movrev/presentation/detail/movie_similar_state.dart';

class MovieSimilarBloc extends Bloc<MovieSimilarEvent, MovieSimilarState> {
  final GetSimilarMoviesUseCase _getSimilarMoviesUseCase;
  final GetGenresUseCase _genresUseCase;
  int _page = 1;

  MovieSimilarBloc(this._getSimilarMoviesUseCase, this._genresUseCase)
    : super(const MovieSimilarState()) {
    on<MovieSimilarInitial>(_onInitial);
    on<MovieSimilarRefresh>(_onInitial);
  }

  Future<void> _onInitial(
    MovieSimilarEvent event,
    Emitter<MovieSimilarState> emit,
  ) async {
    int id;
    if (event is MovieSimilarInitial) {
      id = event.id;
      _page = event.page;
    } else if (event is MovieSimilarRefresh) {
      id = event.id;
      _page = event.page;
    } else {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        movies: const <Movie>[],
        errorMessage: null,
      ),
    );

    try {
      if (state.genres.isEmpty) {
        final genreResult = await _genresUseCase();
        if (!genreResult.hasError) {
          emit(state.copyWith(genres: genreResult.genres));
        }
      }

      final result = await _getSimilarMoviesUseCase(movieId: id, page: _page);

      if (result.errorMessage != null) {
        emit(
          state.copyWith(
            isLoading: false,
            hasMore: false,
            errorMessage: result.errorMessage,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            movies: result.movies,
            hasMore: _page < result.totalPages,
          ),
        );
      }
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

