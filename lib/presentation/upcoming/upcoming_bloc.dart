import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_upcoming_movies_use_case.dart';
import 'package:movrev/presentation/upcoming/upcoming_event.dart';
import 'package:movrev/presentation/upcoming/upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final GetUpcomingMoviesUseCase _getUpcomingMoviesUseCase;
  final GetGenresUseCase _genresUseCase;
  int _page = 1;

  UpcomingBloc(this._getUpcomingMoviesUseCase, this._genresUseCase) : super(const UpcomingState()){
    on<UpcomingInitial>((event, emit)=> _fetchInitial(emit));
    on<UpcomingRefresh>((event, emit)=> _fetchInitial(emit));
    on<UpcomingLoadMore>(_onLoadMore);
  
  }

  ///initial fetch now upcoming movie from the API
  Future<void> _fetchInitial(Emitter<UpcomingState> emit) async {
    _page = 1;
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        movies: const <Movie>[],
        errorMessage: null, // Reset error when loading starts
      ),
    );

    try {

      //Fetch genres if they are not already loaded
      if(state.genres.isEmpty){
        final genreResult = await _genresUseCase();
        if(!genreResult.hasError){
          emit(state.copyWith(genres: genreResult.genres));
        }
      }
      final result = await _getUpcomingMoviesUseCase(page: _page);
      
      // CHECK ERROR FROM RESULT HERE
      if (result.errorMessage != null) {
        emit(
          state.copyWith(
            isLoading: false,
            hasMore: false,
            errorMessage: result.errorMessage, // Get error from Repository
          ),
        );
      } else {
        // IF SUCCESSFUL
        emit(
          state.copyWith(
            isLoading: false,
            movies: result.movies,
            hasMore: _page < result.totalPages,
            // No need to set errorMessage: null again as it is already reset at the start
          ),
        );
      }
    } catch (error) {
      // Fallback for any other exceptions (e.g., usecase mapping errors)
      emit(
        state.copyWith(
          isLoading: false,
          hasMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  ///Fetch load more data
  Future<void> _onLoadMore(
    UpcomingLoadMore event,
    Emitter<UpcomingState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));
    
    try {
      final nextPage = _page + 1;
      final result = await _getUpcomingMoviesUseCase(page: nextPage);
      
      // CHECK ERROR FROM RESULT HERE AS WELL
      if (result.errorMessage != null) {
        emit(
          state.copyWith(
            isLoadingMore: false, 
            errorMessage: result.errorMessage, // Display error when fetching next page
          ),
        );
        return;
      }

      if (result.movies.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }
      
      _page = nextPage;
      emit(
        state.copyWith(
          isLoadingMore: false,
          movies: [...state.movies, ...result.movies],
          hasMore: _page < result.totalPages,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMore: false, errorMessage: error.toString()),
      );
    }
  }
}