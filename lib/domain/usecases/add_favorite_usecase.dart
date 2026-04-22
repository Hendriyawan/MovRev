import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class AddFavoriteUseCase {
  final MovieRepository _repository;
  AddFavoriteUseCase(this._repository);

  Future<void> execute(Movie movie) {
    return _repository.insertFavorite(movie);
  }
}
