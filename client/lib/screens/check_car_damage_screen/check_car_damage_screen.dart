import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_part_container.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_FAB.dart';

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
  bool _isVisibleSPBTN = true;
  bool _isbackTimeSkip = false;
  bool _isforwardTimeSkip = false;
  bool _isSecondTap = false;
  bool video_pause = true;

  int skip_counter = 0;

  List<String> selected_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
    '앞범퍼/앞펜더/전조등',
    '뒷범퍼/뒷펜더/후미등',
    '옆면/사이드/스텝',
    '타이어/휠',
    '기타',
  ];

  late Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void addCategories(String categoryName) {
    setState(() {
      selected_categories.add(categoryName);
    });
  }

  void removeCategories(String categoryName) {
    setState(() {
      selected_categories.remove(categoryName);
    });
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
              video_pause = true;
              _isVisibleSPBTN = true; // 영상이 끝나면 버튼 표시
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
        _isVisibleSPBTN = !_isVisibleSPBTN;
        print(_isVisible);
        _timeChecker();
      },
    );
  }

  // void _watchVideoFast() {
  //   setState(() {
  //     _isVisible = true;
  //     _isTimeSkip = true;
  //   });
  // }
  //
  // void _stopWatchVideoFast() {
  //   setState(() {
  //     _isVisible = false;
  //     _isTimeSkip = false;
  //   });
  // }

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

  void _onDoubleTap() {
    // 두번 탭을 했을 때 실행할 동작
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: MyFABMenu(
        selected_categories: selected_categories,
        addCategories: addCategories,
        removeCategories: removeCategories,
      ),
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
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _isVisible
                                  ? Colors.black54
                                  : Colors.black.withOpacity(0.0),
                            ),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
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
                                                      .value
                                                      .position
                                                      .inSeconds -
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
                                              size: 300,
                                            ),
                                            Positioned(
                                              right: 120,
                                              top: 130,
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
                                                        .value
                                                        .position
                                                        .inSeconds +
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
                                        child: const Stack(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Colors.black38,
                                              size: 300,
                                            ),
                                            Positioned(
                                              left: 130,
                                              top: 130,
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
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 16,
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Container(
                        width: screenWidth * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '현재 필터링',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  selected_categories.length.toString(),
                                  style: TextStyle(
                                    color: Color(0xFFE0426F),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: selected_categories.map(
                                  (category) {
                                    return Chip(
                                      onDeleted: () {
                                        removeCategories(category);
                                        print(category);
                                      },
                                      deleteIcon: const Icon(
                                        Icons.clear_rounded,
                                        size: 16,
                                      ),
                                      label: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      labelPadding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      backgroundColor: Color(0xFFFBD5DC),
                                      deleteIconColor: Color(0xFFE0426F),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            if (selected_categories.isEmpty)
                              Container(
                                height: screenHeight * 0.07,
                                child: const Center(
                                  child: Text('현재 적용된 필터링이 없습니다.'),
                                ),
                              ),
                            Row(
                              children: [
                                Text(
                                  '현재 손상 수',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  selected_categories.length.toString(),
                                  style: TextStyle(
                                    color: Color(0xFFE0426F),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await _videoPlayerController.pause();
                    //     await _videoPlayerController.seekTo(
                    //       Duration(seconds: 5),
                    //     );
                    //     await _videoPlayerController.play();
                    //   },
                    //   child: Text(
                    //     '00:05',
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //       decoration: TextDecoration.underline,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                    CheckCarDamageContainer(),
                  ],
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
