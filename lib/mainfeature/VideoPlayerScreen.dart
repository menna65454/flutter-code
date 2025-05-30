import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final String responseText;

  const VideoPlayerScreen(
      {required this.videoPath, required this.responseText});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _isPlaying = !_isPlaying;
    });
  }

  void _replay() {
    _controller.seekTo(Duration.zero);
    _controller.play();
    setState(() => _isPlaying = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('عرض الفيديو')),
      body: Column(
        children: [
          // تحجيم الفيديو داخل Container مع تحديد العرض والارتفاع
          if (_controller.value.isInitialized)
            Container(
              width: 300, // تحديد عرض الفيديو
              height: 200, // تحديد ارتفاع الفيديو
              child: VideoPlayer(_controller),
            )
          else
            CircularProgressIndicator(),

          // أزرار التحكم بالفيديو
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayback,
              ),
              IconButton(
                icon: Icon(Icons.replay),
                onPressed: _replay,
              ),
            ],
          ),

          // عرض الرد من السيرفر
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: widget.responseText,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "رد السيرفر",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
