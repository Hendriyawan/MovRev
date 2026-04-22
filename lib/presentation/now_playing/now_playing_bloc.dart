import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_now_playing_movies_use_case.dart';
import 'package:movrev/presentation/now_playing/now_playing_event.dart';
import 'package:movrev/presentation/now_playing/now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final GetGenresUseCase _getGenresUseCase;
  int _page = 1;

  NowPlayingBloc(
    this._getNowPlayingMoviesUseCase,
    this._getGenresUseCase,
  ) : super(const NowPlayingState()) {
    on<NowPlayingInitial>((event, emit) => _fetchInitial(emit));
    on<NowPlayingRefresh>((event, emit) => _fetchInitial(emit));
    on<NowPlayingLoadMore>(_onLoadMore);
  }

  ///initial fetch now playing movie from the API
  Future<void> _fetchInitial(Emitter<NowPlayingState> emit) async {
    _page = 1;
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        movies: const <Movie>[],
        errorMessage: null, // Reset error saat mulai memuat
      ),
    );

    try {
      // Fetch genres if they are not already loaded
      if (state.genres.isEmpty) {
        final genreResult = await _getGenresUseCase();
        if (!genreResult.hasError) {
          emit(state.copyWith(genres: genreResult.genres));
        }
      }

      final result = await _getNowPlayingMoviesUseCase(page: _page);
      
      // CEK ERROR DARI RESULT DI SINI
      if (result.errorMessage != null) {
        emit(
          state.copyWith(
            isLoading: false,
            hasMore: false,
            errorMessage: result.errorMessage, // Ambil error dari Repository
          ),
        );
      } else {
        // JIKA SUKSES
        emit(
          state.copyWith(
            isLoading: false,
            movies: result.movies,
            hasMore: _page < result.totalPages,
            // tidak perlu set errorMessage: null lagi karena sudah di-reset di awal
          ),
        );
      }
    } catch (error) {
      // Jaga-jaga jika ada exception lain yang lolos (misal error parsing mapping dari Usecase)
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
    NowPlayingLoadMore event,
    Emitter<NowPlayingState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));
    
    try {
      final nextPage = _page + 1;
      final result = await _getNowPlayingMoviesUseCase(page: nextPage);
      
      // CEK ERROR DARI RESULT DI SINI JUGA
      if (result.errorMessage != null) {
        emit(
          state.copyWith(
            isLoadingMore: false, 
            errorMessage: result.errorMessage, // show error the next fetch page
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