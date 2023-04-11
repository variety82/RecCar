import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_container.dart';
import 'package:client/screens/after_check_damage_screen/after_check_damage_screen.dart';
import 'package:client/screens/check_car_damage_screen/video_full_screen.dart';

class CheckCarDamageScreen extends StatefulWidget {
  final String filePath;
  final List<Map<String, dynamic>> carDamagesAllList;
  final List<int> selectedIndexList;

  const CheckCarDamageScreen({
    Key? key,
    required this.filePath,
    required this.carDamagesAllList,
    required this.selectedIndexList,
  }) : super(key: key);

  @override
  State<CheckCarDamageScreen> createState() => _CheckCarDamageScreenState();
}

class _CheckCarDamageScreenState extends State<CheckCarDamageScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late TabController _tabController;
  final List<Widget> _tabs = [
    const Text('전체 보기'),
    const Text('리스트만 보기'),
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

  List<String> selected_categories = [];

  List<String> damage_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
  ];

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
    _timer.cancel();
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
        // if (_videoPlayerController.value.isPlaying) {
        //   _timeChecker();
        // }
      },
    );
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
      _timer.cancel(); // 기존 타이머 취소
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
      Future.delayed(const Duration(milliseconds: 250), () {
        _isSecondTap = false;
      });
    }
  }

  void changeDamageValue(
    int indexValue,
    String partValue,
    int scratchCount,
    int crushedCount,
    int breakageCount,
    int separatedCount,
    String memoValue,
  ) {
    setState(() {
      carDamagesAllList[indexValue]["part"] = partValue;
      carDamagesAllList[indexValue]["Scratch"] = scratchCount;
      carDamagesAllList[indexValue]["Crushed"] = crushedCount;
      carDamagesAllList[indexValue]["Breakage"] = breakageCount;
      carDamagesAllList[indexValue]["Separated"] = separatedCount;
      carDamagesAllList[indexValue]["memo"] = memoValue;
      carDamagesAllList[indexValue]["selected"] = true;

      if (!selectedIndexList.contains(indexValue)) {
        selectedIndexList.add(indexValue);
      }
      selectedIndexList.sort((a, b) => a.compareTo(b));
      damageView(indexValue);
      // _tabController.animateTo(1);
    });
  }

  void deleteDamageList(int indexValue) {
    setState(
      () {
        carDamagesAllList[indexValue]["selected"] = false;
        selectedIndexList.remove(indexValue);
        // _tabController.animateTo(0);
      },
    );
  }

  void damageView(int indexValue) {
    List<String> damagedParts = [];
    // carDamageList의 인덱스 2, 3, 4, 5의 값을 검사하여 damagedParts 리스트에 추가
    if (carDamagesAllList[indexValue]["Scratch"]! > 0) {
      damagedParts.add("스크래치");
    }
    if (carDamagesAllList[indexValue]["Crushed"]! > 0) {
      damagedParts.add("찌그러짐");
    }
    if (carDamagesAllList[indexValue]["Breakage"]! > 0) {
      damagedParts.add("파손");
    }
    if (carDamagesAllList[indexValue]["Separated"]! > 0) {
      damagedParts.add("이격");
    }

    if (damagedParts.length > 1) {
      setState(() {
        carDamagesAllList[indexValue]["damageView"] =
            '${damagedParts[0]} 외 ${damagedParts.length - 1}건';
      });
    } else if (damagedParts.isNotEmpty) {
      setState(() {
        carDamagesAllList[indexValue]["damageView"] = damagedParts[0];
      });
    } else {
      //
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
      String content, String yesText, String noText,
      {dynamic data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                yesText,
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
                noText,
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

  // List<Map<String, dynamic>> filteredDamagedIndex = [];
  List<int> filteredDamagedIndex = [];

  void changeFilter() {
    filteredDamagedIndex = [];
    if (selected_categories.isEmpty) {
      for (var damage in carDamagesAllList) {
        setState(() {
          filteredDamagedIndex.add(damage['index']);
        });
      }
    } else {
      for (var damage in carDamagesAllList) {
        if (selected_categories.contains('스크래치') &&
            damage['Scratch'] != 0 &&
            !filteredDamagedIndex.contains(damage['index'])) {
          filteredDamagedIndex.add(damage['index']);
        }
        if (selected_categories.contains('찌그러짐') &&
            damage['Crushed'] != 0 &&
            !filteredDamagedIndex.contains(damage['index'])) {
          filteredDamagedIndex.add(damage['index']);
        }
        if (selected_categories.contains('파손') &&
            damage['Breakage'] != 0 &&
            !filteredDamagedIndex.contains(damage['index'])) {
          filteredDamagedIndex.add(damage['index']);
        }
        if (selected_categories.contains('이격') &&
            damage['Separated'] != 0 &&
            !filteredDamagedIndex.contains(damage['index'])) {
          filteredDamagedIndex.add(damage['index']);
        }
      }
    }
    setState(() {
      filteredDamagedIndex.sort((a, b) => a.compareTo(b));
    });
  }

  // timer 시, 분, 초 단위로 표시 전환해줌
  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    _initVideoPlayer();

    carDamagesAllList = widget.carDamagesAllList;
    selectedIndexList = widget.selectedIndexList;

    _tabController = TabController(vsync: this, length: 2); // 탭 수에 따라 length 변경
    int selectedTabIndex = 0; // 기본값은 첫 번째 탭

    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex != selectedTabIndex) {
        setState(() {
          selectedTabIndex = newIndex;
          isSelectedView = !isSelectedView;
        });
      }
    });
    changeFilter();
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
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                height: screenHeight,
                width: screenWidth,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _watchVideoMenu();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        height: 240,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                      .value
                                                      .position
                                                      .inSeconds -
                                                  10),
                                        );
                                        Future.delayed(
                                          const Duration(milliseconds: 200),
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
                                        duration:
                                            const Duration(milliseconds: 200),
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
                                              child: const Column(
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
                                      child: (_isVisibleSPBTN && _isVisible)
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.circle,
                                                  color: Colors.black38,
                                                  size: 80,
                                                ),
                                                _videoPlayerController
                                                        .value.isPlaying
                                                    ? const Icon(
                                                        Icons.pause,
                                                        color: Colors.white,
                                                        size: 40,
                                                      )
                                                    : const Icon(
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
                                      duration:
                                          const Duration(milliseconds: 200),
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
                                            const Duration(milliseconds: 200),
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
                                              child: const Column(
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
                                            const Positioned(
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
                              bottom: 10,
                              left: 10,
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
                                    _durationToString(
                                        _videoPlayerController.value.duration),
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
                              bottom: 5,
                              right: 5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoFullScreen(
                                        filePath: widget.filePath,
                                        timeStamp: _videoPlayerController
                                            .value.position,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.fullscreen,
                                  color: _isVisible
                                      ? Colors.white.withOpacity(0.75)
                                      : Colors.white.withOpacity(0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 동영상 제어(progressindicator) 파트
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        colors: const VideoProgressColors(
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
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              selectedIndexList.isNotEmpty
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AfterCheckDamageScreen(
                                          filePath: widget.filePath,
                                          carDamagesAllList:
                                              widget.carDamagesAllList,
                                        ),
                                      ),
                                    )
                                  // ? showConfirmationDialog(
                                  //     context,
                                  //     goOtherScreen,
                                  //     '손상 등록',
                                  //     '손상을 등록합니다. 정말 괜찮으시겠습니까?',
                                  //     '예',
                                  //     '아니오')
                                  : showConfirmationDialog(
                                      context,
                                      goOtherScreen,
                                      '선택한 손상 없음',
                                      '현재 선택하신 손상이 존재하지 않는 상태입니다. 정말 괜찮으시겠습니까?',
                                      '예',
                                      '아니오');
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            tooltip: '손상을 저장할 수 있습니다.',
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_as,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                          appBar: AppBar(
                            toolbarHeight: 2,
                            backgroundColor: Colors.white,
                            bottom: TabBar(
                              controller: _tabController,
                              labelColor: const Color(0xFFE0426F),
                              unselectedLabelColor: const Color(0xFF989696),
                              indicatorColor: const Color(0xFFE0426F),
                              indicatorWeight: 3,
                              tabs: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: const Text(
                                      "추가 전 손상",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    )),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: const Text(
                                      "추가 후 손상",
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
                              selectedIndexList.length !=
                                          carDamagesAllList.length ||
                                      selected_categories.length !=
                                          filteredDamagedIndex.length ||
                                      filteredDamagedIndex.isNotEmpty
                                  ? CheckCarDamageContainer(
                                      carDamageList: carDamagesAllList,
                                      videoPlayerController:
                                          _videoPlayerController,
                                      changeDamageValue: changeDamageValue,
                                      selectedIndexList: selectedIndexList,
                                      isSelectedView: false,
                                      deleteDamageList: deleteDamageList,
                                      showConfirmationDialog:
                                          showConfirmationDialog,
                                      filteredDamagedIndex:
                                          filteredDamagedIndex,
                                    )
                                  : const Center(
                                      child: Text('추가 전 손상이 존재하지 않습니다.'),
                                    ),
                              selectedIndexList.isNotEmpty
                                  ? CheckCarDamageContainer(
                                      carDamageList: carDamagesAllList,
                                      videoPlayerController:
                                          _videoPlayerController,
                                      changeDamageValue: changeDamageValue,
                                      selectedIndexList: selectedIndexList,
                                      isSelectedView: true,
                                      deleteDamageList: deleteDamageList,
                                      showConfirmationDialog:
                                          showConfirmationDialog,
                                      filteredDamagedIndex:
                                          filteredDamagedIndex,
                                    )
                                  : const Center(
                                      child: Text('추가 예정인 손상이 존재하지 않습니다.'),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                        const Text(
                                          '현재 개수',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          isSelectedView
                                              ? selectedIndexList.length
                                                  .toString()
                                              : (carDamagesAllList.length -
                                                      selectedIndexList.length)
                                                  .toString(),
                                          style: const TextStyle(
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
                                  (partCategory) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          if (selected_categories
                                              .contains(partCategory)) {
                                            setState(() {
                                              removeCategories(partCategory);
                                            });
                                          } else {
                                            setState(
                                              () {
                                                addCategories(partCategory);
                                              },
                                            );
                                          }
                                          changeFilter();
                                        },
                                        child: Chip(
                                          label: Text(
                                            partCategory,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: selected_categories
                                                      .contains(partCategory)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .disabledColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          backgroundColor: selected_categories
                                                  .contains(partCategory)
                                              ? Theme.of(context)
                                                  .primaryColorLight
                                              : Theme.of(context).shadowColor,
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
            : const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE0426F),
                ),
              ),
      ),
    );
  }
}
