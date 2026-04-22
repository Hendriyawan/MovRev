import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<MovieResult> call({required String query, int page = 1}) {
    return repository.searchMovies(query: query, page: page);
  }
}
