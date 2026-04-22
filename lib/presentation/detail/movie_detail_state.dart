import 'package:movrev/domain/entities/cast.dart';
import 'package:movrev/domain/entities/movie_detail.dart';
import 'package:movrev/domain/entities/video.dart';


const _detailMovieNoValue = Object();

class MovieDetailState {
  final bool isLoading;
  final MovieDetail detail;
  final String? errorMessage;

  final List<Cast> casts;
  final bool isCastLoading;
  final String? castErrorMessage;

  final List<Video> videos;
  final bool isVideoLoading;
  final String? videoErrorMessage;


  const MovieDetailState({
    this.isLoading = false,
    this.detail = const MovieDetail(),
    this.errorMessage,
    this.casts = const <Cast>[],
    this.isCastLoading = false,
    this.castErrorMessage,
    this.videos = const <Video>[],
    this.isVideoLoading = false,
    this.videoErrorMessage,
  });

  MovieDetailState copyWith({
    bool? isLoading,
    MovieDetail? detail,
    List<Cast>? casts,
    bool? isCastLoading,
    List<Video>? videos,
    bool? isVideoLoading,
    Object? errorMessage = _detailMovieNoValue,
    Object? castErrorMessage = _detailMovieNoValue,
    Object? videoErrorMessage = _detailMovieNoValue,
  }) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      casts: casts ?? this.casts,
      isCastLoading: isCastLoading ?? this.isCastLoading,
      videos: videos ?? this.videos,
      isVideoLoading: isVideoLoading ?? this.isVideoLoading,
      errorMessage: identical(errorMessage, _detailMovieNoValue)
          ? this.errorMessage
          : errorMessage as String?,
      castErrorMessage: identical(castErrorMessage, _detailMovieNoValue)
          ? this.castErrorMessage
          : castErrorMessage as String?,
      videoErrorMessage: identical(videoErrorMessage, _detailMovieNoValue)
          ? this.videoErrorMessage
          : videoErrorMessage as String?,
    );
  }
}
