import 'package:movrev/domain/repositories/movie_repository.dart';

class RemoveFavoriteUseCase {
  final MovieRepository _repository;
  RemoveFavoriteUseCase(this._repository);

  Future<void> execute(int id) {
    return _repository.removeFavorite(id);
  }
}
