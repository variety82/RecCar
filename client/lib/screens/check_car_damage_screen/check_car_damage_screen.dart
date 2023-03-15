import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CheckCarDamageScreen extends StatefulWidget {
  final String filePath;

  const CheckCarDamageScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<CheckCarDamageScreen> createState() => _CheckCarDamageScreenState();
}

class _CheckCarDamageScreenState extends State<CheckCarDamageScreen> {
  late VideoPlayerController _videoPlayerController;
  bool loading_api = true;
  bool video_pause = false;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    // await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // 이후 Future.wait으로 다수 비동기 작업(비디오 임시 저장소에서 불러오기, api 신호 받아오기) 수행하도록 조치할 것
        future: Future.wait([
          _initVideoPlayer(),
        ]),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xFFE0426F),
            ));
          } else {
            return Column(
              children: [
                _videoPlayerController.value.isInitialized
                    ? RotatedBox(
                        quarterTurns: 3, // 시계 방향으로 90도 회전시킵니다.
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      )
                    : Container(),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    colors: VideoProgressColors(
                      backgroundColor: Color(0xFF453F52),
                      bufferedColor: Color(0xFFEFEFEF),
                      playedColor: Color(0xFFE0426F),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _videoPlayerController.seekTo(Duration(
                            seconds: _videoPlayerController
                                    .value.position.inSeconds -
                                10));
                      },
                      child: Icon(Icons.fast_rewind),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _videoPlayerController.pause();
                      },
                      child: Icon(Icons.pause),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _videoPlayerController.play();
                      },
                      child: Icon(Icons.play_arrow),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _videoPlayerController.seekTo(Duration(
                            seconds: _videoPlayerController
                                    .value.position.inSeconds +
                                10));
                      },
                      child: Icon(Icons.fast_forward),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    await _videoPlayerController.pause();
                    await _videoPlayerController.seekTo(
                      Duration(seconds: 5),
                    );
                    await _videoPlayerController.play();
                  },
                  child: Text(
                    '00:05',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
