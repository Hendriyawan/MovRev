import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository repository;

  GetNowPlayingMoviesUseCase(this.repository);

  Future<MovieResult> call({int page = 1}) {
    return repository.getNowPlayingMovies(page: page);
  }
}
