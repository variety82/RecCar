import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/after_recording_screen/after_recording_screen.dart';

class CheckVideoPage extends StatefulWidget {
  final String filePath;

  const CheckVideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _CheckVideoPageState createState() => _CheckVideoPageState();
}

class _CheckVideoPageState extends State<CheckVideoPage> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool loading_video = false;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.filePath),
    );
    await _videoPlayerController.initialize();
    setState(
      () {
        loading_video = true;
      },
    );
    await _videoPlayerController.pause();
  }

  @override
  void initState() {
    _initVideoPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double aspectRatio = _videoPlayerController.value.aspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('영상 미리 확인하기'),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      extendBodyBehindAppBar: true,
      body: loading_video
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE0426F),
              ),
            ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black26.withOpacity(0.5),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                _videoPlayerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                _isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
            ),
            Divider(
              height: 5,
              thickness: 10,
              color: Colors.white.withOpacity(0.5),
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                final route = MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => AfterRecordingScreen(
                    filePath: widget.filePath,
                  ),
                );
                Navigator.push(context, route);
              },
            )
          ],
        ),
      ),
    );
  }
}
