import 'cast_model.dart';

class CastResponseModel {
  final int? id;
  final List<CastModel>? cast;
  const CastResponseModel({
    this.id,
    this.cast,
  });

  factory CastResponseModel.fromJson(Map<String, dynamic> json) =>
      CastResponseModel(
        id: json['id'] as int?,
        cast: (json['cast'] as List<dynamic>?)
            ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cast': cast?.map((e) => e.toJson()).toList(),
      };

}
