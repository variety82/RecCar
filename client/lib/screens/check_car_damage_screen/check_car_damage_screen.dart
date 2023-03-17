import 'dart:io';
import 'dart:async';

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
  bool loading_video = false;

  bool _isVisible = true;
  bool video_pause = true;

  late Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
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
    _videoPlayerController.addListener(
      () {
        // if (!_videoPlayerController.value.isPlaying) {
        //   // 동영상이 재생 중이지 않을 때 수행할 작업
        //   setState(
        //     () {
        //       _isVisible = true;
        //     },
        //   );
        // }
        if (_videoPlayerController.value.position >=
            _videoPlayerController.value.duration) {
          setState(
            () {
              _isVisible = true;
              video_pause = true; // 영상이 끝나면 버튼 표시
            },
          );
        }
      },
    );
    // await _videoPlayerController.setLooping(true);
    // await _videoPlayerController.play();
  }

  void _watchVideoMenu() {
    setState(
      () {
        _isVisible = !_isVisible;
        print(_isVisible);
      },
    );
  }

  void _timeChecker() {
    const duration = Duration(seconds: 3); // 버튼이 사라지는 시간 설정 (3초)
    _timer = Timer(
      duration,
      () {
        if (_isVisible && !video_pause) {
          print('video_pause');
          print(video_pause);
          setState(
            () {
              _isVisible = false; // 버튼 숨기기
            },
          );
        }
      },
    );
  }

  void _resetTimer() {
    if (_isVisible) {
      _timer?.cancel(); // 기존 타이머 취소
      _timeChecker(); // 새로운 타이머 시작
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading_video
          ? Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _watchVideoMenu();
                  },
                  child: RotatedBox(
                    quarterTurns: 3, // 시계 방향으로 90도 회전시킵니다.
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_videoPlayerController),
                          AnimatedOpacity(
                            opacity: _isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 100),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_isVisible) {
                                      if (video_pause) {
                                        _videoPlayerController.play();
                                        setState(() {
                                          video_pause = false;
                                        });
                                        _timeChecker();
                                      } else {
                                        _videoPlayerController.pause();
                                        setState(() {
                                          video_pause = true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _isVisible = true;
                                      });
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.black38,
                                        size: 80,
                                      ),
                                      _videoPlayerController.value.isPlaying
                                          ? Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 40,
                                            )
                                          : Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                        _videoPlayerController.seekTo(
                          Duration(
                              seconds: _videoPlayerController
                                      .value.position.inSeconds +
                                  10),
                        );
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
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE0426F),
              ),
            ),
    );
  }
}
