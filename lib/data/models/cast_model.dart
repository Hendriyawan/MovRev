import '../../domain/entities/cast.dart';

class CastModel extends Cast {
  const CastModel({
    super.adult,
    super.gender,
    super.id,
    super.knownForDepartment,
    super.name,
    super.originalName,
    super.popularity,
    super.profilePath,
    super.castId,
    super.character,
    super.creditId,
    super.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) => CastModel(
        adult: json['adult'] as bool?,
        gender: json['gender'] as int?,
        id: json['id'] as int?,
        knownForDepartment: json['known_for_department'] as String?,
        name: json['name'] as String?,
        originalName: json['original_name'] as String?,
        popularity: (json['popularity'] as num?)?.toDouble(),
        profilePath: json['profile_path'] as String?,
        castId: json['cast_id'] as int?,
        character: json['character'] as String?,
        creditId: json['credit_id'] as String?,
        order: json['order'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'gender': gender,
        'id': id,
        'known_for_department': knownForDepartment,
        'name': name,
        'original_name': originalName,
        'popularity': popularity,
        'profile_path': profilePath,
        'cast_id': castId,
        'character': character,
        'credit_id': creditId,
        'order': order,
      };

}
