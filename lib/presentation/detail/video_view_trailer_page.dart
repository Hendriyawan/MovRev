import 'package:flutter/material.dart';
import 'package:movrev/core/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoViewTrailerPage extends StatefulWidget {
  final String videoKey;
  const VideoViewTrailerPage({super.key, required this.videoKey});

  @override
  State<VideoViewTrailerPage> createState() => _VideoViewTrailerPageState();
}

class _VideoViewTrailerPageState extends State<VideoViewTrailerPage> {
  late YoutubePlayerController _playerController;
  final bool _isPlayerReady = true;

  @override
  void initState() {
    super.initState();
    _playerController = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
      ),
    )..addListener(listener);
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_playerController.value.isFullScreen) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debug("VIDEO KEY : ${widget.videoKey}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: Colors.black26),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _playerController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onReady: () {
                _playerController.addListener(listener);
              },
            ),
          ],
        ),
      ),
    );
  }
}
