import 'package:movrev/domain/entities/genre.dart';

class GenreResult {
  final List<Genre> genres;
  final String? errorMessage;

  const GenreResult({
    required this.genres,
    this.errorMessage,
  });


  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}