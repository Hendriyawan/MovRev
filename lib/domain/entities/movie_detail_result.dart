import 'package:movrev/domain/entities/movie_detail.dart';

class MovieDetailResult {
  final MovieDetail? detail;
  final String? errorMessage;

  const MovieDetailResult({required this.detail, required this.errorMessage});

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
