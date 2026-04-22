import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetPopularMoviesUseCase {
  final MovieRepository repository;

  GetPopularMoviesUseCase(this.repository);

  Future<MovieResult> call({int page = 1}) {
    return repository.getPopularMovies(page: page);
  }
}
