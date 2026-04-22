import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/data/models/cast_response_model.dart';
import 'package:movrev/data/models/genre_response_model.dart';
import 'package:movrev/data/models/movie_detail_response_model.dart';
import 'package:movrev/data/models/video_response_model.dart';
import '../models/movie_response_model.dart';
import 'api_service.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponseModel> getNowPlaying({int page = 1});
  Future<MovieResponseModel> getUpComing({int page = 1});
  Future<MovieResponseModel> getTopRated({int page = 1});
  Future<MovieResponseModel> getPopular({int page = 1});
  Future<MovieResponseModel> getSimilar({required int movieId, int page = 1});
  Future<MovieResponseModel> searchMovies({
    required String query,
    int page = 1,
  });
  Future<MovieResponseModel> getMoviesByGenre({
    required int genreId,
    int page = 1,
  });
  Future<GenreResponseModel> getGenres();
  Future<MovieDetailResponseModel> getMovieDetail({required int id});
  Future<CastResponseModel> getCast({required int movieId});
  Future<VideoResponseModel> getVides({required int movieId});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiService apiService;

  MovieRemoteDataSourceImpl({required this.apiService});

  @override
  Future<MovieResponseModel> getMoviesByGenre({
    required int genreId,
    int page = 1,
  }) async {
    final String url =
        '${AppConfig.baseUrl}/discover/movie?language=en-US&with_genres=$genreId&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<MovieResponseModel> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final String url =
        '${AppConfig.baseUrl}/search/movie?language=en-US&query=$query&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<MovieResponseModel> getNowPlaying({int page = 1}) async {
    final String url =
        '${AppConfig.baseUrl}/movie/now_playing?language=en-US&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<MovieResponseModel> getUpComing({int page = 1}) async {
    final String url =
        '${AppConfig.baseUrl}/movie/upcoming?language=en-US&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<GenreResponseModel> getGenres() async {
    final String url = '${AppConfig.baseUrl}/genre/movie/list?language=en';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final genreResponse = GenreResponseModel.fromJson(response);
    return genreResponse;
  }

  @override
  Future<MovieResponseModel> getPopular({int page = 1}) async {
    final String url =
        '${AppConfig.baseUrl}/movie/popular?language=en-US&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<MovieResponseModel> getTopRated({int page = 1}) async {
    final String url =
        '${AppConfig.baseUrl}/movie/top_rated?language=en-US&page=$page';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }

  @override
  Future<MovieDetailResponseModel> getMovieDetail({required int id}) async {
    final String url = '${AppConfig.baseUrl}/movie/$id?language=en-US';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieDetailResponse = MovieDetailResponseModel.fromJson(response);
    return movieDetailResponse;
  }

  @override
  Future<CastResponseModel> getCast({required int movieId}) async {
    final String url =
        '${AppConfig.baseUrl}/movie/$movieId/credits?language=en-US';
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final castResponse = CastResponseModel.fromJson(response);
    return castResponse;
  }

  @override
  Future<MovieResponseModel> getSimilar({
    required int movieId,
    int page = 1,
  }) async {
    final String url =
        "${AppConfig.baseUrl}/movie/$movieId/similar?language=en-US&page=$page";
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final movieResponse = MovieResponseModel.fromJson(response);
    return movieResponse;
  }
  
  @override
  Future<VideoResponseModel> getVides({required int movieId}) async {
    final String url = "${AppConfig.baseUrl}/movie/$movieId/videos?language=en-US";
    final response = await apiService.getResponse(url, {
      'Authorization': AppConfig.apiKey,
    });
    final videoResponse = VideoResponseModel.fromJson(response);
    return videoResponse;
  }
}
