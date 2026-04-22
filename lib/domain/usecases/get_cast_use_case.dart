import 'package:movrev/domain/entities/cast_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetCastUseCase {
  final MovieRepository repository;

  GetCastUseCase(this.repository);

  Future<CastResult> call({required int id}) {
    return repository.getCast(movieId: id);
  }
}
