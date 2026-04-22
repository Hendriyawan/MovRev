import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class SearchMovieUseCase {
  final MovieRepository repository;
  SearchMovieUseCase(this.repository);

  Future<MovieResult> execute(String query, {int page = 1}) {
    return repository.searchMovies(query: query, page: page);
  }
}
