import 'package:movrev/domain/entities/movie_result.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';

class NowPlayingUsecase {
  final MovieRepository repository;

  NowPlayingUsecase(this.repository);
  
  Future<MovieResult> getNowPlaying({int page = 1}){
    return repository.getNowPlayingMovies(page: page);
  }
}