import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class AddFavoriteUseCase {
  final MovieRepository repository;

  AddFavoriteUseCase(this.repository);
  Future<void> call(Movie movie) {
    return repository.insertFavorite(movie);
  }
}
