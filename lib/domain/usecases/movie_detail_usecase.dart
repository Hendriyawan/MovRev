import 'package:movrev/domain/entities/cast_result.dart';
import 'package:movrev/domain/entities/movie_detail_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class MovieDetailUsecase {
  final MovieRepository repository;
  MovieDetailUsecase(this.repository);
  Future<MovieDetailResult> getMovieDetail({required int id}){
    return repository.getMovieDetail(id: id);
  }

  Future<CastResult> getCast({required int id}){
    return repository.getCast(movieId: id);
  }
}