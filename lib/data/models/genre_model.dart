import '../../domain/entities/genre.dart';

class GenreModel extends Genre {
  const GenreModel({
    super.id,
    super.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  factory GenreModel.fromEntity(Genre entity) => GenreModel(
        id: entity.id,
        name: entity.name,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

}
