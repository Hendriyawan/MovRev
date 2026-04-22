import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class SimilarUsecacse {
  final MovieRepository repository;
  SimilarUsecacse(this.repository);
  Future<MovieResult> getSimilar({required int movieId, int page = 1}){
    return repository.getSimilar(movieId: movieId, page: page);
  }
}