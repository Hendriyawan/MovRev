import 'video_model.dart';

class VideoResponseModel {
  final int? id;
  final List<VideoModel>? results;

  const VideoResponseModel({
    this.id,
    this.results,
  });

  factory VideoResponseModel.fromJson(Map<String, dynamic> json) =>
      VideoResponseModel(
        id: json['id'] as int?,
        results: (json['results'] as List<dynamic>?)
            ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'results': results?.map((e) => e.toJson()).toList(),
      };
}
