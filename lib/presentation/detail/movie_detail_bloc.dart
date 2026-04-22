import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/cast_result.dart';
import 'package:movrev/domain/entities/movie_detail_result.dart';
import 'package:movrev/domain/usecases/get_movie_detail_use_case.dart';
import 'package:movrev/domain/usecases/get_cast_use_case.dart';
import 'package:movrev/domain/usecases/get_video_usecase.dart';
import 'package:movrev/domain/entities/video_result.dart';
import 'package:movrev/presentation/detail/movie_detail_event.dart';
import 'package:movrev/presentation/detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final GetCastUseCase _getCastUseCase;
  final GetVideoUsecase _getVideoUsecase;

  MovieDetailBloc(
    this._getMovieDetailUseCase,
    this._getCastUseCase,
    this._getVideoUsecase,
    
  ) : super(const MovieDetailState()) {
    on<MovieDetailLoad>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        isCastLoading: true,
        isVideoLoading: true,
        errorMessage: null,
        castErrorMessage: null,
        videoErrorMessage: null,
      ));
      try {
        final results = await Future.wait([
          _getMovieDetailUseCase(id: event.id),
          _getCastUseCase(id: event.id),
          _getVideoUsecase.getVideos(movieId: event.id),
        ]);
        final detailResult = results[0] as MovieDetailResult;
        final castResult = results[1] as CastResult;
        final videoResult = results[2] as VideoResult;
        emit(
          state.copyWith(
            isLoading: false,
            isCastLoading: false,
            isVideoLoading: false,
            detail: detailResult.detail,
            casts: castResult.cast,
            videos: videoResult.videos,
            errorMessage: detailResult.errorMessage ??
                (detailResult.detail == null ? 'Unknown error' : null),
            castErrorMessage: castResult.errorMessage,
            videoErrorMessage: videoResult.errorMessage,
          ),
        );
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          isCastLoading: false,
          isVideoLoading: false,
          errorMessage: e.toString(),
          castErrorMessage: e.toString(),
          videoErrorMessage: e.toString(),
        ));
      }
    });
  }
}

