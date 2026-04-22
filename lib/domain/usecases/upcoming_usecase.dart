import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class UpcomingUsecase {
  final MovieRepository repository;

  UpcomingUsecase(this.repository);

  Future<MovieResult> getUpcoming({int page = 1}) {
    return repository.getUpcomingMovies(page: page);
  }
}
