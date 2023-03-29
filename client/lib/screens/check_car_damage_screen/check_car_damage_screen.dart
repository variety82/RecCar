import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_container.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_FAB.dart';
import 'package:client/services/analysis_car_damage_api.dart';

class CheckCarDamageScreen extends StatefulWidget {
  final String filePath;

  const CheckCarDamageScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<CheckCarDamageScreen> createState() => _CheckCarDamageScreenState();
}

class _CheckCarDamageScreenState extends State<CheckCarDamageScreen> {
  late VideoPlayerController _videoPlayerController;
  bool loading_api = false;
  bool loading_video = false;

  bool _isVisible = true;
  bool _isVisibleSPBTN = true;
  bool _isbackTimeSkip = false;
  bool _isforwardTimeSkip = false;
  bool _isSecondTap = false;
  bool video_pause = true;

  int skip_counter = 0;

  List<dynamic> carDamageInfo = [];

  List<String> selected_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
  ];

  List<String> damage_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
  ];

  List<Map<String, dynamic>> carDamagesAllList = [];
  List<Map<String, dynamic>> selectedCarDamagesList = [];

  late Timer _timer;

  void turnSwitch() {}
  bool _isView = false;

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController.dispose();
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [
    //     SystemUiOverlay.top,
    //     SystemUiOverlay.bottom,
    //   ],
    // );
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

  void changeDamageValue(
    int indexValue,
    String partValue,
    int scratch_count,
    int crushed_count,
    int breakage_count,
    int separated_count,
    String memoValue,
  ) {
    setState(() {
      carDamageInfo[indexValue - 1]["part"] = partValue;
      carDamageInfo[indexValue - 1]["damage"]["scratch"] = scratch_count;
      carDamageInfo[indexValue - 1]["damage"]["crushed"] = crushed_count;
      carDamageInfo[indexValue - 1]["damage"]["breakage"] = breakage_count;
      carDamageInfo[indexValue - 1]["damage"]["separated"] = separated_count;
      carDamageInfo[indexValue - 1]["memo"] = memoValue;
      carDamageInfo[indexValue - 1]["selected"] = true;
      selectedCarDamagesList.add(carDamageInfo[indexValue - 1]);
    });
  }

  @override
  void initState() {
    _initVideoPlayer();

    analysisCarDamageApi(
      success: (dynamic response) {
        print(response[0]);
        int time_cnt = 0;
        int index_cnt = 0;
        for (int i = 0; i < response.length; i++) {
          index_cnt += 1;
          print(response[i]['url']);
          Map<String, dynamic> carDamageState = {
            "index": index_cnt,
            "Damage_Image_URL": response[i]['url'],
            "part": "",
            "damage": {
              "scratch": 0,
              "crushed": 0,
              "breakage": 0,
              "separated": 0,
            },
            "timeStamp": time_cnt,
            "memo": "",
            "selected": false,
          };
          carDamageState["damage"][carDamageState["damage"]] += 1;
          carDamagesAllList.add(carDamageState);
          if (index_cnt % 3 == 0) {
            time_cnt += 1;
          }
        }
        // List<Map<String, dynamic>> carDamagesList = [];
        // carDamagesList = response.map((Map<String, dynamic> carDamage) {
        //   print('carDamage');
        //   print(carDamage['url']);
        //   String url = carDamage["url"];
        //   String damage_sort = carDamage["damage"];
        //   index_cnt += 1;
        //   Map<String, dynamic> carDamageState = {
        //     "Damage_Image_URL": url,
        //     "part": "",
        //     "damage": damage_sort,
        //     "timeStamp": time_cnt,
        //     "memo": "",
        //   };
        //   if (index_cnt % 3 == 0) {
        //     time_cnt += 1;
        //   }
        //   print(carDamage);
        //   return carDamageState;
        // }).toList();
        setState(() {
          // carDamagesAllList = carDamagesList;
          carDamageInfo = response;
          loading_api = true;
        });
      },
      fail: (error) {
        print(error);
        print('차량 손상 분석 오류: $error');
        setState(
          () {
            loading_api = true;
          },
        );
      },
      filePath: widget.filePath,
      user_id: 1,
    );
    // setState(
    //   () {
    //     loading_api = true;
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: MyFABMenu(
          selected_categories: selected_categories,
          addCategories: addCategories,
          removeCategories: removeCategories,
        ),
        body: loading_video
            ? Container(
                height: screenHeight,
                width: screenWidth,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _watchVideoMenu();
                      },
                      child: RotatedBox(
                        quarterTurns: 3, // 시계 방향으로 90도 회전시킵니다.
                        // 수정해야 할 듯 함... 예상되는 비율 받아온 후 AspectRatio 적용
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: Stack(
                            children: [
                              VideoPlayer(_videoPlayerController),
                              Container(
                                height: screenHeight,
                                width: screenWidth,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                  seconds:
                                                      _videoPlayerController
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
                                            opacity:
                                                _isbackTimeSkip ? 1.0 : 0.0,
                                            duration:
                                                Duration(milliseconds: 200),
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
                                          opacity:
                                              _isforwardTimeSkip ? 1.0 : 0.0,
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
                                                    seconds:
                                                        _videoPlayerController
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
                      width: double.infinity,
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
                    Container(
                      color: Colors.white,
                      width: screenWidth,
                      height: 80,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: damage_categories.map(
                                      (part_category) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () {
                                              if (selected_categories
                                                  .contains(part_category)) {
                                                setState(() {
                                                  removeCategories(
                                                      part_category);
                                                });
                                              } else {
                                                setState(
                                                  () {
                                                    addCategories(
                                                        part_category);
                                                  },
                                                );
                                              }
                                            },
                                            child: Chip(
                                                label: Text(
                                                  part_category,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                labelPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                                backgroundColor:
                                                    selected_categories
                                                            .contains(
                                                                part_category)
                                                        ? Color(0xFFFBD5DC)
                                                        : Colors.grey
                                                // deleteIconColor: Color(0xFFE0426F),
                                                ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _isView
                                            ? Icon(
                                                Icons.fact_check,
                                              )
                                            : Icon(
                                                Icons.fact_check_outlined,
                                              ),
                                        Switch(
                                          value: _isView,
                                          onChanged: (value) {
                                            setState(() {
                                              _isView = !_isView;
                                            });
                                          },
                                          activeColor: Color(0xFFE0426F),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
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
                                      _isView
                                          ? selectedCarDamagesList.length
                                              .toString()
                                          : carDamagesAllList.length.toString(),
                                      style: TextStyle(
                                        color: Color(0xFFE0426F),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
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
                    Expanded(
                      child: loading_api
                          ? CheckCarDamageContainer(
                              carDamageList: _isView
                                  ? selectedCarDamagesList
                                  : carDamagesAllList,
                              videoPlayerController: _videoPlayerController,
                              changeDamageValue: changeDamageValue,
                            )
                          : Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE0426F),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE0426F),
                ),
              ),
      ),
    );
  }
}
