import 'package:movrev/domain/entities/movie.dart';

class FavoriteState {
  final List<Movie> favorites;
  final bool isLoading;
  final String? errorMessage;
  final bool isFavorite;

  const FavoriteState({
    this.favorites = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isFavorite = false,
  });

  FavoriteState copyWith({
    List<Movie>? favorites,
    bool? isLoading,
    String? errorMessage,
    bool? isFavorite,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
