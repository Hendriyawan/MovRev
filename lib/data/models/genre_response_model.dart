import 'genre_model.dart';

class GenreResponseModel {
  final List<GenreModel>? genres;

  const GenreResponseModel({
    this.genres,
  });

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) {
    return GenreResponseModel(
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'genres': genres?.map((e) => e.toJson()).toList(),
      };
}
