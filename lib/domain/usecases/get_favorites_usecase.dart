import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetFavoritesUseCase {
  final MovieRepository _repository;
  GetFavoritesUseCase(this._repository);

  Future<List<Movie>> execute() {
    return _repository.getFavorites();
  }
}
