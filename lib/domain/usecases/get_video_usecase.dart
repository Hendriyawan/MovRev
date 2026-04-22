import 'package:movrev/domain/entities/video_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class GetVideoUsecase {
  final MovieRepository repository;

  const GetVideoUsecase(this.repository);

  Future<VideoResult> getVideos({required int movieId}) {
    return repository.getVideos(movieId: movieId);
  }
}
