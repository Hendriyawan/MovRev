import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetMoviesByGenreUseCase {
  final MovieRepository _repository;
  GetMoviesByGenreUseCase(this._repository);

  Future<MovieResult> execute({required int genreId, int page = 1}) {
    return _repository.getMoviesByGenre(genreId: genreId, page: page);
  }
}
