
import 'movie.dart';

class MovieResult {
  final List<Movie> movies;
  final int totalPages;
  final int page;
  final String? errorMessage;

  const MovieResult({
    required this.movies,
    required this.totalPages,
    required this.page,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
