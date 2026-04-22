import 'package:movrev/domain/repositories/movie_repository.dart';

class IsFavoriteUseCase {
  final MovieRepository _repository;
  IsFavoriteUseCase(this._repository);

  Future<bool> execute(int id) {
    return _repository.isFavorite(id);
  }
}
