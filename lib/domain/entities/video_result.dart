import 'video.dart';

class VideoResult {
  final int? id;
  final List<Video>? videos;
  final String? errorMessage;

  const VideoResult({
    this.id,
    this.videos,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
