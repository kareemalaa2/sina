import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerModal extends StatefulWidget {
  const VideoPlayerModal({
    super.key,
    required this.controller,
  });
  final CachedVideoPlayerPlusController controller;

  @override
  State<VideoPlayerModal> createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends State<VideoPlayerModal> {
  @override
  void initState() {
    widget.controller.play();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (widget.controller.value.isPlaying) {
              widget.controller.pause();
            } else {
              widget.controller.play();
            }
          },
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: CachedVideoPlayerPlus(widget.controller),
          ),
        ),
      ],
    );
  }
}
