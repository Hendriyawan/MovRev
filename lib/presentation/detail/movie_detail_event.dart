abstract class MovieDetailEvent {}

class MovieDetailLoad extends MovieDetailEvent {
  final int id;
  MovieDetailLoad(this.id);
}