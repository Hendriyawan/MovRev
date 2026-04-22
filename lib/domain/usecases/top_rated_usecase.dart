import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class TopRatedUsecase {
  final MovieRepository repository;


  TopRatedUsecase(this.repository);

  Future<MovieResult> getTopRated({int page = 1}) {
    return repository.getTopRated(page: page);
  }
}