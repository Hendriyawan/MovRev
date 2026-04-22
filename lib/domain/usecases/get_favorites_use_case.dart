import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetFavoritesUseCase {
  final MovieRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getFavorites();
  }
}
