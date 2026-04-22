import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetTopRatedMoviesUseCase {
  final MovieRepository repository;

  GetTopRatedMoviesUseCase(this.repository);

  Future<MovieResult> call({int page = 1}) {
    return repository.getTopRated(page: page);
  }
}
