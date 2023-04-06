import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_container.dart';
import 'package:client/screens/after_check_damage_screen/after_check_damage_screen.dart';

class VideoFullScreen extends StatefulWidget {
  final String filePath;
  final List<Map<String, dynamic>> carDamagesAllList;
  final List<int> selectedIndexList;
  final Duration timeStamp;

  const VideoFullScreen({
    Key? key,
    required this.filePath,
    required this.carDamagesAllList,
    required this.selectedIndexList,
    required this.timeStamp,
  }) : super(key: key);

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late TabController _tabController;
  final List<Widget> _tabs = [
    Text('전체 보기'),
    Text('리스트만 보기'),
  ];
  bool loading_api = true;
  bool loading_video = false;

  bool _isVisible = true;
  bool _isVisibleSPBTN = true;
  bool _isbackTimeSkip = false;
  bool _isforwardTimeSkip = false;
  bool _isSecondTap = false;
  bool video_pause = true;
  bool isSelectedView = false;

  int skip_counter = 0;

  List<dynamic> carDamageInfo = [];

  List<Map<String, dynamic>> carDamagesAllList = [];
  List<Map<String, dynamic>> selectedCarDamagesList = [];
  List<int> selectedIndexList = [];
  int nowDamageCnt = 0;

  void changeDamageCnt(int changedCnt) {
    setState(() {
      nowDamageCnt = changedCnt;
    });
  }

  late Timer _timer;

  void turnSwitch() {}

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
    await _videoPlayerController.pause();
    await _videoPlayerController.seekTo(
      widget.timeStamp,
    );
    _videoPlayerController.addListener(
      () {
        if (_videoPlayerController.value.position >=
            _videoPlayerController.value.duration) {
          setState(
            () {
              _isVisible = true;
              video_pause = true;
              _isVisibleSPBTN = true; // 영상이 끝나면 버튼 표시
            },
          );
        }
      },
    );
  }

  // timer 시, 분, 초 단위로 표시 전환해줌
  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _watchVideoMenu() {
    setState(
      () {
        _isVisible = !_isVisible;
        _isVisibleSPBTN = !_isVisibleSPBTN;
        _timeChecker();
      },
    );
  }

  void _timeChecker() {
    const duration = Duration(seconds: 3); // 버튼이 사라지는 시간 설정 (3초)
    _timer = Timer(
      duration,
      () {
        if (_isVisible && !video_pause) {
          setState(
            () {
              _isVisible = false;
              _isVisibleSPBTN = false; // 버튼 숨기기
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

  // 개선하던가 없애던가 해야함~~~~
  void _onTapDown(TapDownDetails details) {
    if (_isSecondTap) {
      // 두번째 탭을 눌렀을 때의 동작
      setState(() {
        skip_counter += 1;
      });
    } else {
      // 첫번째 탭을 눌렀을 때의 동작
      _timeChecker();
      _isSecondTap = true;
      Future.delayed(Duration(milliseconds: 250), () {
        _isSecondTap = false;
      });
    }
  }

  void goOtherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfterCheckDamageScreen(
          filePath: widget.filePath,
          carDamagesAllList: widget.carDamagesAllList,
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, Function func, String title,
      String content, String yes_text, String no_text,
      {dynamic data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                yes_text,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // Yes 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(
                no_text,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // No 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        if (data != null) {
          func(data);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AfterCheckDamageScreen(
                filePath: widget.filePath,
                carDamagesAllList: widget.carDamagesAllList,
              ),
            ),
          );
        }
      } else if (value == false) {
        // No 버튼을 눌렀을 때 수행할 작업
      }
    });
  }

  @override
  void initState() {
    _initVideoPlayer();

    carDamagesAllList = widget.carDamagesAllList;
    selectedIndexList = widget.selectedIndexList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double aspectRatio = _videoPlayerController.value.aspectRatio;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: loading_video
            ? Container(
                height: screenHeight,
                width: screenWidth,
                child: GestureDetector(
                  onTap: () {
                    _watchVideoMenu();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    height: screenHeight,
                    width: screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(_videoPlayerController)),
                        Container(
                          decoration: BoxDecoration(
                            color: _isVisible
                                ? Colors.black54
                                : Colors.black.withOpacity(0.0),
                          ),
                          child: OverflowBox(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    _watchVideoMenu();
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      _isVisibleSPBTN = false;
                                      _isVisible = true;
                                      _isbackTimeSkip = true;
                                    });
                                    _videoPlayerController.seekTo(
                                      Duration(
                                          seconds: _videoPlayerController
                                                  .value.position.inSeconds -
                                              10),
                                    );
                                    Future.delayed(
                                      Duration(milliseconds: 200),
                                      () {
                                        setState(() {
                                          _isVisible = false;
                                          _isbackTimeSkip = false;
                                        });
                                      },
                                    );
                                  },
                                  child: AnimatedOpacity(
                                    opacity: _isbackTimeSkip ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 200),
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Colors.black38,
                                          size: screenWidth,
                                        ),
                                        Positioned(
                                          right: (screenWidth / 4) + 10,
                                          top: (screenWidth / 2) - 10,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.fast_rewind,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Text(
                                                '10초',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
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
                                        _timeChecker();
                                      });
                                    }
                                  },
                                  child: _isVisibleSPBTN
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Colors.black38,
                                              size: 80,
                                            ),
                                            _videoPlayerController
                                                    .value.isPlaying
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
                                        )
                                      : Container(),
                                ),
                                AnimatedOpacity(
                                  opacity: _isforwardTimeSkip ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 200),
                                  child: InkWell(
                                    onTap: () {
                                      _watchVideoMenu();
                                    },
                                    onDoubleTap: () {
                                      setState(() {
                                        _isVisibleSPBTN = false;
                                        _isVisible = true;
                                        _isforwardTimeSkip = true;
                                      });
                                      _videoPlayerController.seekTo(
                                        Duration(
                                            seconds: _videoPlayerController
                                                    .value.position.inSeconds +
                                                10),
                                      );
                                      Future.delayed(
                                        Duration(milliseconds: 200),
                                        () {
                                          setState(() {
                                            _isVisible = false;
                                            _isforwardTimeSkip = false;
                                          });
                                        },
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Colors.black38,
                                          size: screenWidth,
                                        ),
                                        Positioned(
                                          left: (screenWidth / 4) + 10,
                                          top: (screenWidth / 2) - 10,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.fast_forward,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Text(
                                                '10초',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 12,
                                          bottom: 12,
                                          child: Row(
                                            children: [
                                              Text(
                                                'data',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          left: 30,
                          child: Row(
                            children: [
                              Text(
                                "${_durationToString(_videoPlayerController.value.position)} / ",
                                style: TextStyle(
                                  color: _isVisible
                                      ? Colors.white.withOpacity(0.75)
                                      : Colors.white.withOpacity(0),
                                ),
                              ),
                              Text(
                                "${_durationToString(_videoPlayerController.value.duration)}",
                                style: TextStyle(
                                  color: _isVisible
                                      ? Colors.white.withOpacity(0.75)
                                      : Colors.white.withOpacity(0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          right: 30,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.fullscreen_exit,
                              color: _isVisible
                                  ? Colors.white.withOpacity(0.75)
                                  : Colors.white.withOpacity(0),
                            ),
                          ),
                        ),
                        _isVisible
                            ? Positioned(
                                bottom: 40,
                                child: Container(
                                  height: 16,
                                  width: screenWidth,
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
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              )
            // 동영상 제어(progressindicator) 파트
            : Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE0426F),
                ),
              ),
      ),
    );
  }
}
