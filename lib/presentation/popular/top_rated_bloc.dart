import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_top_rated_movies_use_case.dart';
import 'package:movrev/presentation/popular/top_rated_event.dart';
import 'package:movrev/presentation/popular/top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMoviesUseCase _getTopRatedMoviesUseCase;
  final GetGenresUseCase _genresUseCase;
  int _page = 1;

  TopRatedBloc(this._getTopRatedMoviesUseCase, this._genresUseCase): super(const TopRatedState()){
    on<TopRatedInitial>((event, emit) => _fetchInitial(emit));
    on<TopRatedRefresh>((event, emit) => _fetchInitial(emit));
    on<TopRatedLoadMore>(_onLoadMore);
  }

  ///initial fetch top rated movie from the api
  Future<void> _fetchInitial(Emitter<TopRatedState> emit) async {
    _page = 1;
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore:  false,
        hasMore: true,
        movies: const <Movie>[],
        errorMessage: null,
      )
    );
    try {
      if(state.genres.isEmpty){
        final genreResult = await _genresUseCase();
        if(!genreResult.hasError){
          emit(state.copyWith(genres: genreResult.genres));
        }
      }
      final result = await _getTopRatedMoviesUseCase(page: _page);

      ///check error here
      if(result.errorMessage != null){
        emit(state.copyWith(
          isLoading: false,
          hasMore:  false,
          errorMessage: result.errorMessage
        ));
      } else {
        //if success
        emit(state.copyWith(
          isLoading: false,
          movies: result.movies,
          hasMore:  _page < result.totalPages,
        ));
      }
    } catch(error){
      //Fallback for any other exceptions (e.g. usecase mapping errors)
      emit(state.copyWith(
        isLoading: false,
        hasMore: false,
        errorMessage: error.toString()
      ));
    }
  }

  ///Fetch load more data
  Future<void> _onLoadMore(
    TopRatedLoadMore event,
    Emitter<TopRatedState> emit,
  ) async {
    if(state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final nextPage = _page + 1;
      final result = await _getTopRatedMoviesUseCase(page: nextPage);
      ///check error from result here as well
      if(result.errorMessage != null){
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: result.errorMessage
        ));
        return;
      }
      if(result.movies.isEmpty){
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }
      _page = nextPage;
      emit(state.copyWith(
        isLoadingMore: false,
        movies: [...state.movies, ...result.movies],
        hasMore: _page < result.totalPages,
      ));

    } catch(error){
      emit(state.copyWith(isLoadingMore: false, errorMessage: error.toString()));
    }
  }
}