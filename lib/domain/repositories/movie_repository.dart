import 'package:movrev/domain/entities/cast_result.dart';
import 'package:movrev/domain/entities/genre_result.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/entities/movie_detail_result.dart';
import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/entities/video_result.dart';

abstract class MovieRepository {
  Future<MovieResult> getNowPlayingMovies({int page = 1});
  Future<MovieResult> getUpcomingMovies({int page = 1});
  Future<MovieResult> getPopularMovies({int page = 1});
  Future<MovieDetailResult> getMovieDetail({required int id});
  Future<MovieResult> getTopRated({int page = 1});
  Future<GenreResult> getGenres();
  Future<CastResult> getCast({required int movieId});
  Future<MovieResult> getSimilar({required int movieId, int page = 1});
  Future<MovieResult> searchMovies({required String query, int page = 1});
  Future<MovieResult> getMoviesByGenre({required int genreId, int page = 1});
  ///Videos
  Future<VideoResult> getVideos({required int movieId});
  
  // Favorites
  Future<void> insertFavorite(Movie movie);
  Future<void> removeFavorite(int id);
  Future<List<Movie>> getFavorites();
  Future<bool> isFavorite(int id);
}
