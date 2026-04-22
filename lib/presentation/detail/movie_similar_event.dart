abstract class MovieSimilarEvent {}

class MovieSimilarInitial extends MovieSimilarEvent {
  final int id;
  final int page;
  MovieSimilarInitial(this.id, this.page);
}

class MovieSimilarRefresh extends MovieSimilarEvent {
  final int id;
  final int page;
  MovieSimilarRefresh(this.id, this.page);
}
