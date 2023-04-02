import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/screens/check_video_screen/check_video_screen.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';

// 내부 요소 실시간 변경되므로 Stateful Widget 생성
class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  // state 생성
  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with WidgetsBindingObserver {
  // class 내부에서만 쓰는 변수는 캡슐화를 위해 _(언더바) 붙임

  // 현재 상태 알려주는 변수 지정
  // _nowLoading은 처음 화면 시작한 후 카메라 initialized 모두 끝나고 녹화 직전까지 화면 구현 되면 false로 바뀌고, 그 때까지는 true로 유지
  bool _nowLoading = true;

  // _nowRecording은 녹화 중일 때는 true, 그렇지 않을 때면 false임
  bool _nowRecording = false;

  // 현재 카메라 initailizing이 된 상태인지 여부를 boolean 값으로 구분
  bool _nowcameraInitialized = false;

  // 현재 카메라&녹음 허가가 받아진 상태인지 구분
  bool _nowCameraPermissionGranted = false;

  // 현재 허가가 어떤 식으로 거부당했는지 구분
  String _nowReasonDeniedCamera = '';

  // 현재 녹화 관련 기능에 어떤 오류가 있는지 구분
  // 디렉토리, 카메라 순
  String _nowReasonDirectoryError = '';
  String _nowReasonCameraError = '';

  // 현재 앞면 카메라 선택한 상태인지 구분
  bool _nowSelectFrontCamera = false;

  // 카메라 컨트롤러와 플래쉬 모드는 이후 값 들어오면 배정해주기 위해 late로 배정해줌
  late CameraController _cameraController;
  late FlashMode _nowFlashMode;

  // 파일 경로도 나중에 지정해줄 것이므로 late로 배정
  late String nowFilePath;

  // 파일 저장될 디렉토리 경로도 불러옴
  Future<void> getVideoFilePath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${directory.path}/video');
      await videoDir.create(recursive: true);
      final filePath =
          '${videoDir.path}/REC${DateTime.now().millisecondsSinceEpoch}.mp4';
      nowFilePath = filePath;
    } catch (err) {
      print('$err로 인해 디렉토리 경로 불러오기 실패');
    }
  }

  // 가능한 카메라 목록 불러오기 위해 avaliableCameraList 생성
  List<CameraDescription> avaliableCameraList = [];

  // 카메라 및 녹음 기능 사용을 위해 permission_handler를 이용함
  void _cameraPermission() async {
    // 권한 부여되지 않았을 시 권한 요청 후 결과 받아와 requestStatus에 저장
    await Permission.camera.request();
    // 현재 권한 부여 상태가 어떤지 nowPermissionStatus로 받아옴
    var cameraPermissionStatus = await Permission.camera.status;
    // 만약 카메라 권한이 허용되었거나(isGranted == true), 제한적 허가 되었다면(isLimited)
    if (cameraPermissionStatus.isGranted || cameraPermissionStatus.isLimited) {
      // 카메라 권한 허용 시 녹음 권한 요청
      await Permission.microphone.request();
      var microphonePermissionStatus = await Permission.microphone.status;
      // 카메라 및 녹음 권한 요청에 모두 성공했을 시
      // setState로 _nowCameraPermissionGranted 값을 true로 바꿔줌
      if (microphonePermissionStatus.isGranted ||
          microphonePermissionStatus.isLimited) {
        setState(() {
          _nowCameraPermissionGranted = true;
          _nowReasonDeniedCamera = '모든 권한 요청 승인';
        });
      } else {
        setState(() {
          _nowReasonDeniedCamera = '녹음 권한 요청 거부';
        });
      }

      // 만약 사용자가 (영구) 권한 요청 거부를 선택했을 시, appsetting에서 직접 변경할 수 있게 함(안드로이드)
    } else if (cameraPermissionStatus.isPermanentlyDenied ||
        cameraPermissionStatus.isDenied) {
      setState(() {
        _nowReasonDeniedCamera = '카메라 권한 요청 거부';
      });
      // openAppSettings();
      // 만약 사용자가 다시는 알람을 표시하지 않게 했을 시(ios), 마찬가지로 appsetting에서 변경할 수 있게 함
    } else if (cameraPermissionStatus.isRestricted) {
      setState(() {
        _nowReasonDeniedCamera = '알람 표시 거부';
      });
      // openAppSettings();
    }
  }

  // 파일 옮겨서 원하는 경로, 원하는 이미지로 다시 저장하려고 만든 함수임
  // 허나 사용할 지는 모르겠음(일단 방치)
  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  // recording을 멈출 때, 파일이 저장된 경로를 돌려받음
  Future<String> stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return 'none';
    }
    try {
      // stopVideoRecording에서 return한 영상 정보를 videoFile에 저장한 후, 경로를 myFilePath에 저장함
      // 이후 해당 경로를 return함
      _nowLoading = true;
      XFile? videoFile = await _cameraController.stopVideoRecording();
      String myFilePath = videoFile.path;
      return myFilePath;
    } catch (err) {
      print('$err로 인해 녹화 실패');
      return 'error';
    }
  }

  // 타이머 관련 변수 및 함수 설정
  Timer? stopwatch;
  int _timeCounter = 0;

  void _startTimer() {
    stopwatch = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeCounter++;
      });
    });
  }

  void _stopTimer() {
    if (stopwatch != null) {
      setState(() {
        stopwatch!.cancel();
        stopwatch = null;
        _timeCounter = 0;
      });
    }
  }

  void _pauseTimer() {
    if (stopwatch != null) {
      setState(() {
        stopwatch!.cancel();
        stopwatch = null;
      });
    }
  }

  void _resumeTimer() {
    if (stopwatch == null) {
      setState(() {
        stopwatch = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _timeCounter++;
          });
        });
      });
    }
  }

  // timer 시, 분, 초 단위로 표시 전환해줌
  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // 녹화 화면으로 들어올 시, initState로 필요한 요소들을 초기화해줌
  @override
  void initState() {
    // 하단바만 보이게 조절
    _cameraPermission();
    _initCamera();
    getVideoFilePath();

    super.initState();
  }

  // 녹화 화면을 벗어날 시, 메모리 누수 방지를 위해 dispose함
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    }
    //    else if (state == AppLifecycleState.resumed) {
    //       onNewCameraSelected(cameraController.description);
    //     }
  }

  // camera 초기 설정
  Future<void> _initCamera() async {
    try {
      // 먼저 현재 기기 내에서 사용 가능한 카메라 목록을 전부 불러옴
      List<CameraDescription> availableCameraList = await availableCameras();
      // 후면 카메라 선택
      final back = availableCameraList.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      // 후면 카메라를 선택한 후, 영상 해상도를 최대로 선택함
      _cameraController = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // 컨트롤러를 초기화함
      await _cameraController.initialize();
      _nowFlashMode = FlashMode.auto;
      await _cameraController.setFlashMode(_nowFlashMode);
      setState(() {
        _nowLoading = false;
      });

      print(_nowLoading);
    } catch (err) {
      print('$err로 인해 카메라 initialized 실패');
    }
  }

  void changeCameraDirection() async {
    // 현재 사용 중인 카메라 정보 가져오기
    final currentController = _cameraController.description;

    // 현재 사용 중인 카메라와 반대 방향의 카메라를 가져옴
    final newController = avaliableCameraList.firstWhere(
      (description) =>
          description.lensDirection != currentController.lensDirection,
      orElse: () => throw Exception('카메라를 찾을 수 없습니다.'),
    );

    // 현재 작동 중인 컨트롤러 멈춘 후, 새로운 카메라로 전환시켜 실행
    await _cameraController.dispose();
    _cameraController = CameraController(
      newController,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _cameraController.initialize();
    // _nowSelecteFrontCamera 변수값 수정
    setState(() {
      _nowSelectFrontCamera = !_nowSelectFrontCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 핸드폰의 회전 상태를 orientation에 저장
    final Orientation orientation = MediaQuery.of(context).orientation;
    // 스크린 가로, 세로 길이 구해서 각각 변수 배정
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      // 핸드폰 현재 구성에 맞춰 ui 구성할 수 있도록 SafeArea로 감싸줌
      child: Scaffold(
        body: _nowCameraPermissionGranted
            ? _nowLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                          child: CameraPreview(
                        _cameraController,
                      )),
                      Positioned(
                        top: 16,
                        left: (orientation == Orientation.portrait)
                            ? MediaQuery.of(context).size.width / 2 - 90
                            : MediaQuery.of(context).size.height / 2,
                        child: Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              "${_durationToString(Duration(seconds: _timeCounter))}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (_nowFlashMode != FlashMode.torch) {
                                    setState(() {
                                      _nowFlashMode = FlashMode.torch;
                                    });
                                    await _cameraController!.setFlashMode(
                                      FlashMode.torch,
                                    );
                                  } else {
                                    setState(() {
                                      _nowFlashMode = FlashMode.off;
                                    });
                                    await _cameraController!.setFlashMode(
                                      FlashMode.off,
                                    );
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black38,
                                      size: 60,
                                    ),
                                    Icon(
                                      Icons.highlight,
                                      color: _nowFlashMode == FlashMode.torch
                                          ? Colors.amber
                                          : Colors.white,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              _nowRecording
                                  ? Container(
                                      height: 80,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (_cameraController
                                                  .value.isRecordingPaused) {
                                                try {
                                                  await _cameraController
                                                      .resumeVideoRecording();
                                                  setState(() {
                                                    // _nowRecording = true;
                                                    _resumeTimer();
                                                  });
                                                } on CameraException catch (err) {
                                                  print('$err로 인해 녹화 재개 불가');
                                                }
                                              } else {
                                                try {
                                                  await _cameraController
                                                      .pauseVideoRecording();
                                                  setState(() {
                                                    // _nowRecording = false;
                                                    _pauseTimer();
                                                  });
                                                } on CameraException catch (err) {
                                                  print('$err로 인해 녹화 멈춤 불가');
                                                }
                                              }
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                _cameraController!
                                                        .value.isRecordingPaused
                                                    ? const Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            color: Colors.white,
                                                            size: 42,
                                                          ),
                                                          Icon(
                                                            Icons.circle,
                                                            color: Colors.red,
                                                            size: 30,
                                                          ),
                                                        ],
                                                      )
                                                    : Icon(
                                                        Icons.pause_rounded,
                                                        color: Colors.black,
                                                        size: 42,
                                                      ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              _stopTimer();
                                              setState(
                                                () {
                                                  _nowcameraInitialized = false;
                                                  _nowRecording = false;
                                                },
                                              );
                                              String videoFilePath =
                                                  await stopRecording();
                                              final route = MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (_) => CheckVideoPage(
                                                    filePath: videoFilePath),
                                              );
                                              Navigator.pop(context);
                                              Navigator.push(context, route);
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(
                                                  Icons.square_rounded,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  // 동영상 촬영 시작 시
                                  : InkWell(
                                      onTap: () async {
                                        // await startVideoRecording();
                                        try {
                                          await _cameraController
                                              .startVideoRecording();
                                          setState(() {
                                            _nowRecording = true;
                                            _startTimer();
                                          });
                                        } on CameraException catch (err) {
                                          print('$err로 인해 녹화 시작 불가');
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.white,
                                            size: 80,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                              _nowRecording
                                  ? InkWell(
                                      onTap: () async {},
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.black38,
                                            size: 60,
                                          ),
                                          // Icon(
                                          //   Icons.circle,
                                          //   color: Colors.white,
                                          //   size: 40,
                                          // ),
                                          Icon(
                                            Icons.camera,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        changeCameraDirection();
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.black38,
                                            size: 60,
                                          ),
                                          Icon(
                                            !_nowSelectFrontCamera
                                                ? Icons.camera_front
                                                : Icons.camera_rear,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('현재 ${_nowReasonDeniedCamera}된 상태입니다.'),
                    Text('설정에서 권한을 허가해주시기 바랍니다.'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(200, 40),
                        backgroundColor: Color(0xFFE0426F),
                      ),
                      onPressed: () {
                        openAppSettings();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '설정으로 이동',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
