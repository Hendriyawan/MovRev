import 'package:movrev/domain/entities/genre_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetGenresUseCase {
  final MovieRepository repository;

  GetGenresUseCase(this.repository);

  Future<GenreResult> call() {
    return repository.getGenres();
  }
}
