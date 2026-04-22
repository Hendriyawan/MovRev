import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetSimilarMoviesUseCase {
  final MovieRepository repository;

  GetSimilarMoviesUseCase(this.repository);

  Future<MovieResult> call({required int movieId, int page = 1}) {
    return repository.getSimilar(movieId: movieId, page: page);
  }
}
