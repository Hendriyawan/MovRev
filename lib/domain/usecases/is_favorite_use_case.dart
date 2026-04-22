import 'package:movrev/domain/repositories/movie_repository.dart';

class IsFavoriteUseCase {
  final MovieRepository repository;

  IsFavoriteUseCase(this.repository);

  Future<bool> call(int id) {
    return repository.isFavorite(id);
  }
}
