import 'dart:io';

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

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
              final route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => AfterRecordingScreen(),
              );
              Navigator.push(context, route);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xFFE0426F),
            ));
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}
