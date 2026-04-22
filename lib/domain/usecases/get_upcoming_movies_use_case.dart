import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetUpcomingMoviesUseCase {
  final MovieRepository repository;

  GetUpcomingMoviesUseCase(this.repository);

  Future<MovieResult> call({int page = 1}) {
    return repository.getUpcomingMovies(page: page);
  }
}
