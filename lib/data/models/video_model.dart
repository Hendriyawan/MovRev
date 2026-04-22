import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    super.iso6391,
    super.iso31661,
    super.name,
    super.key,
    super.site,
    super.size,
    super.type,
    super.official,
    super.publishedAt,
    super.id,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        iso6391: json['iso_639_1'] as String?,
        iso31661: json['iso_3166_1'] as String?,
        name: json['name'] as String?,
        key: json['key'] as String?,
        site: json['site'] as String?,
        size: json['size'] as int?,
        type: json['type'] as String?,
        official: json['official'] as bool?,
        publishedAt: json['published_at'] as String?,
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'iso_639_1': iso6391,
        'iso_3166_1': iso31661,
        'name': name,
        'key': key,
        'site': site,
        'size': size,
        'type': type,
        'official': official,
        'published_at': publishedAt,
        'id': id,
      };
}
