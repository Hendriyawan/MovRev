import 'package:movrev/domain/entities/genre_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetGenresUsecase {
  final MovieRepository repository;

  GetGenresUsecase(this.repository);

  Future<GenreResult> execute() {
    return repository.getGenres();
  }
}
