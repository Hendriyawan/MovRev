import 'package:movrev/domain/entities/movie_detail_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetMovieDetailUseCase {
  final MovieRepository repository;

  GetMovieDetailUseCase(this.repository);

  Future<MovieDetailResult> call({required int id}) {
    return repository.getMovieDetail(id: id);
  }
}
