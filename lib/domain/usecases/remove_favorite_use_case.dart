import 'package:movrev/domain/repositories/movie_repository.dart';

class RemoveFavoriteUseCase {
  final MovieRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(int id) {
    return repository.removeFavorite(id);
  }
}
