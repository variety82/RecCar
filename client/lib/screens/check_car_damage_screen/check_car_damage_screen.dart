import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_container.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_FAB.dart';
import 'package:client/services/analysis_car_damage_api.dart';
import 'package:client/provider/car_damage_info_provider/car_damage_info_provider.dart';

class CheckCarDamageScreen extends StatefulWidget {
  final String filePath;
  final List<Map<String, dynamic>> carDamagesAllList;

  const CheckCarDamageScreen({
    Key? key,
    required this.filePath,
    required this.carDamagesAllList,
  }) : super(key: key);

  @override
  State<CheckCarDamageScreen> createState() => _CheckCarDamageScreenState();
}

class _CheckCarDamageScreenState extends State<CheckCarDamageScreen>
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

  // ValueNotifier<List<Map<String, dynamic>>> damageInfoNotifier =
  //     DamageInfoNotifier([]);
  //
  // void _updateDamageInfo(newDamageInfo) {
  //   damageInfoNotifier = newDamageInfo;
  // }

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
    print("aspectratio@@@@");
    print(_videoPlayerController.value.aspectRatio);
    setState(
      () {
        loading_video = true;
      },
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
    // await _videoPlayerController.setLooping(true);
    // await _videoPlayerController.play();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // 선택된 탭이 변경되었을 때 실행될 코드 작성
      isSelectedView = !isSelectedView;
    }
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
      // print(indexValue);
      widget.carDamagesAllList[indexValue - 1]["part"] = partValue;
      widget.carDamagesAllList[indexValue - 1]["Scratch"] = scratch_count;
      widget.carDamagesAllList[indexValue - 1]["Crushed"] = crushed_count;
      widget.carDamagesAllList[indexValue - 1]["Breakage"] = breakage_count;
      widget.carDamagesAllList[indexValue - 1]["Separated"] = separated_count;
      widget.carDamagesAllList[indexValue - 1]["memo"] = memoValue;
      widget.carDamagesAllList[indexValue - 1]["selected"] = true;

      if (!selectedIndexList.contains(indexValue - 1)) {
        selectedIndexList.add(indexValue - 1);
      }
      selectedIndexList.sort((a, b) => a.compareTo(b));
    });
  }

  @override
  void initState() {
    _initVideoPlayer();
    // _updateDamageInfo(widget.carDamagesAllList);
    _tabController = TabController(vsync: this, length: 2); // 탭 수에 따라 length 변경
    int _selectedTabIndex = 0; // 기본값은 첫 번째 탭

    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = newIndex;
          isSelectedView = !isSelectedView;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double aspectRatio = _videoPlayerController.value.aspectRatio;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        quarterTurns: aspectRatio > 1 ? 0 : 3,
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Stack(
                            children: [
                              VideoPlayer(_videoPlayerController),
                              AspectRatio(
                                aspectRatio: aspectRatio,
                                child: Container(
                                  // height: screenHeight,
                                  // width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: _isVisible
                                        ? Colors.black54
                                        : Colors.black.withOpacity(0.0),
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: aspectRatio > 1 ? 0 : 1,
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
                                                    size: screenWidth,
                                                  ),
                                                  Positioned(
                                                    right:
                                                        (screenWidth / 4) + 10,
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
                                                  _videoPlayerController
                                                      .pause();
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
                                                              color:
                                                                  Colors.white,
                                                              size: 40,
                                                            )
                                                          : Icon(
                                                              Icons.play_arrow,
                                                              color:
                                                                  Colors.white,
                                                              size: 40,
                                                            ),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                          AnimatedOpacity(
                                            opacity:
                                                _isforwardTimeSkip ? 1.0 : 0.0,
                                            duration:
                                                Duration(milliseconds: 200),
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
                                                      _isforwardTimeSkip =
                                                          false;
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
                                                    left:
                                                        (screenWidth / 4) + 10,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 동영상 제어(progressindicator) 파트
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
                    // 자동차 각 손상 확인 파트
                    Expanded(
                      flex: 2,
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          floatingActionButton:
                              // MyFABMenu(
                              //   selected_categories: selected_categories,
                              //   addCategories: addCategories,
                              //   removeCategories: removeCategories,
                              //   filePath: widget.filePath,
                              //   carDamagesAllList: widget.carDamagesAllList,
                              //   selectedIndexList: selectedIndexList,
                              // ),
                              FloatingActionButton(
                            onPressed:
                                selectedIndexList.length > 0 ? () {} : null,
                            backgroundColor: Theme.of(context).primaryColor,
                            tooltip: '손상을 저장할 수 있습니다.',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.save_as,
                                  size: 14,
                                ),
                                Text(
                                  '저장',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          appBar: AppBar(
                            toolbarHeight: 2,
                            backgroundColor: Colors.white,
                            bottom: TabBar(
                              controller: _tabController,
                              labelColor: Color(0xFFE0426F),
                              unselectedLabelColor: Color(0xFF989696),
                              indicatorColor: Color(0xFFE0426F),
                              indicatorWeight: 3,
                              tabs: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      "전체 보기",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    )),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      "리스트만 보기",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            controller: _tabController,
                            children: [
                              CheckCarDamageContainer(
                                carDamageList: widget.carDamagesAllList,
                                videoPlayerController: _videoPlayerController,
                                changeDamageValue: changeDamageValue,
                                selectedIndexList: selectedIndexList,
                                isSelectedView: false,
                                // damageInfoNotifier: damageInfoNotifier,
                              ),
                              CheckCarDamageContainer(
                                carDamageList: widget.carDamagesAllList,
                                videoPlayerController: _videoPlayerController,
                                changeDamageValue: changeDamageValue,
                                selectedIndexList: selectedIndexList,
                                isSelectedView: true,
                                // damageInfoNotifier: damageInfoNotifier,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: loading_api
                    //       ? CheckCarDamageContainer(
                    //           carDamageList: widget.carDamagesAllList,
                    //           videoPlayerController: _videoPlayerController,
                    //           changeDamageValue: changeDamageValue,
                    //           selectedIndexList: selectedIndexList,
                    //           isSelectedView: isSelectedView,
                    //         )
                    //       : Container(
                    //           child: Center(
                    //             child: CircularProgressIndicator(
                    //               color: Color(0xFFE0426F),
                    //             ),
                    //           ),
                    //         ),
                    // ),
                    Container(
                      color: Colors.white,
                      width: screenWidth,
                      height: 50,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '현재 개수',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          isSelectedView
                                              ? selectedIndexList.length
                                                  .toString()
                                              : (widget.carDamagesAllList
                                                          .length -
                                                      selectedIndexList.length)
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color(0xFFE0426F),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          if (selected_categories
                                              .contains(part_category)) {
                                            setState(() {
                                              removeCategories(part_category);
                                            });
                                          } else {
                                            setState(
                                              () {
                                                addCategories(part_category);
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
                                            labelPadding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: selected_categories
                                                    .contains(part_category)
                                                ? Color(0xFFFBD5DC)
                                                : Colors.grey
                                            // deleteIconColor: Color(0xFFE0426F),
                                            ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

// isSelectedView
//     ? Icon(
//         Icons.fact_check,
//       )
//     : Icon(
//         Icons.fact_check_outlined,
//       ),
// Switch(
//   value: isSelectedView,
//   onChanged: (value) {
//     setState(() {
//       isSelectedView = !isSelectedView;
//     });
//   },
//   activeColor: Color(0xFFE0426F),
// ),
