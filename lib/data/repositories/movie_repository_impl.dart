import 'package:movrev/data/datasource/movie_local_data_source.dart';
import 'package:movrev/data/datasource/movie_remote_data_source.dart';
import 'package:movrev/data/models/movie_model.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/entities/cast_result.dart';
import 'package:movrev/domain/entities/genre_result.dart';
import 'package:movrev/domain/entities/movie_detail_result.dart';
import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/entities/video_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl({
    required MovieRemoteDataSource remoteDataSource,
    required MovieLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<MovieResult> getNowPlayingMovies({int page = 1}) async {
    try {
      final result = await _remoteDataSource.getNowPlaying(page: page);
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<MovieResult> getUpcomingMovies({int page = 1}) async {
    try {
      final result = await _remoteDataSource.getUpComing(page: page);
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<MovieResult> getPopularMovies({int page = 1}) async {
    try {
      final result = await _remoteDataSource.getPopular(page: page);
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<GenreResult> getGenres() async {
    try {
      final result = await _remoteDataSource.getGenres();
      return GenreResult(genres: result.genres ?? []);
    } catch (e) {
      return GenreResult(genres: [], errorMessage: e.toString());
    }
  }

  @override
  Future<MovieResult> getTopRated({int page = 1}) async {
    try {
      final result = await _remoteDataSource.getTopRated(page: page);
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<MovieDetailResult> getMovieDetail({required int id}) async {
    try {
      final result = await _remoteDataSource.getMovieDetail(id: id);
      return MovieDetailResult(detail: result, errorMessage: null);
    } catch (e) {
      return MovieDetailResult(detail: null, errorMessage: e.toString());
    }
  }

  @override
  Future<CastResult> getCast({required int movieId}) async {
    try {
      final result = await _remoteDataSource.getCast(movieId: movieId);
      return CastResult(
        id: result.id,
        cast: result.cast ?? [],
        errorMessage: null,
      );
    } catch (e) {
      return CastResult(id: 0, cast: [], errorMessage: e.toString());
    }
  }

  @override
  Future<MovieResult> getSimilar({required int movieId, int page = 1}) async {
    try {
      final result = await _remoteDataSource.getSimilar(
        movieId: movieId,
        page: page,
      );
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<MovieResult> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.searchMovies(
        query: query,
        page: page,
      );
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<MovieResult> getMoviesByGenre({
    required int genreId,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getMoviesByGenre(
        genreId: genreId,
        page: page,
      );
      return MovieResult(
        movies: result.results ?? [],
        totalPages: result.totalPages ?? 0,
        page: page,
      );
    } catch (e) {
      return MovieResult(
        movies: [],
        totalPages: 0,
        page: page,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> insertFavorite(Movie movie) async {
    final movieModel = MovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
    );
    await _localDataSource.insertFavorite(movieModel);
  }

  @override
  Future<void> removeFavorite(int id) async {
    await _localDataSource.removeFavorite(id);
  }

  @override
  Future<List<Movie>> getFavorites() async {
    return await _localDataSource.getFavorites();
  }

  @override
  Future<bool> isFavorite(int id) async {
    return await _localDataSource.isFavorite(id);
  }

  @override
  Future<VideoResult> getVideos({required int movieId}) async {
    try {
      final result = await _remoteDataSource.getVides(movieId: movieId);
      return VideoResult(
        id: result.id,
        videos: result.results ?? [],
        errorMessage: null,
      );
    } catch (e) {
      return VideoResult(id: 0, videos: [], errorMessage: e.toString());
    }
  }
}
