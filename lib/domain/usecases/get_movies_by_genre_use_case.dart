import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetMoviesByGenreUseCase {
  final MovieRepository repository;

  GetMoviesByGenreUseCase(this.repository);

  Future<MovieResult> call({required int genreId, int page = 1}) {
    return repository.getMoviesByGenre(genreId: genreId, page: page);
  }
}
