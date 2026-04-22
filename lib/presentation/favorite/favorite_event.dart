import 'package:movrev/domain/entities/movie.dart';

abstract class FavoriteEvent {}

class FetchFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Movie movie;
  ToggleFavorite(this.movie);
}

class CheckFavoriteStatus extends FavoriteEvent {
  final int id;
  CheckFavoriteStatus(this.id);
}
