import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class PopularUsecase {
  final MovieRepository repository;

  PopularUsecase(this.repository);

  Future<MovieResult> getPopular({int page = 1}) {
    return repository.getPopularMovies(page: page);
  }
}