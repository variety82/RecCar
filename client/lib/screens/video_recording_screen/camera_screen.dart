import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/screens/video_recording_screen/preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  VideoPlayerController? videoController;

  File? _videoFile;

  // Initial values
  List<CameraDescription> cameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;

  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = true;

  bool _isRecordingInProgress = false;

  // 최소, 최대 줌 레벨 설정
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // 최소, 최대 화면 크기(해상도?) 레벨 설정
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  // Current values
  // 현재 줌 레벨
  double _currentZoomLevel = 1.0;

  // 현재 화면 크기 레벨
  double _currentExposureOffset = 0.0;

  // 플래쉬 켰는지, 키지 않았는지 여부 확인
  FlashMode? _currentFlashMode;

  List<File> allFileList = [];

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  // 카메라/녹음 기능 접근 허가
  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
      refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }

  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      if (recentFileName.contains('.mp4')) {
        _videoFile = File('${directory.path}/$recentFileName');
      } else {
        _videoFile = null;
      }
      setState(() {});
    }
  }

  // 현재 사용할 수 있는 카메라 목록 가져옴
  Future<void> getCameras() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fecting the cameras: $e');
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  // Future<void> _startVideoPlayer() async {
  //   if (_videoFile != null) {
  //     videoController = VideoPlayerController.file(_videoFile!);
  //     await videoController!.initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized,
  //       // even before the play button has been pressed.
  //       setState(() {});
  //     });
  //     await videoController!.setLooping(true);
  //     await videoController!.play();
  //   }
  // }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
        print(_isRecordingInProgress);
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }

    try {
      XFile file = await controller!.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
      });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      // 현재 카메라 기능 모두 가져옴
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  // 만약 사용자가 화면의 한 부분을 탭한다면, 그 부분의 좌표를 가져와 finder 효과를 줌
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    // Hide the status bar in Android
    // 하단바만 보이게 조절
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
      ],
    );
    // 카메라 정보 가져오기
    getCameras();
    // 카메라, 마이크 장치 허락 받기
    getPermissionStatus();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    final deviceRatio = screen_size.width / screen_size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isCameraPermissionGranted
            ? _isCameraInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: deviceRatio,
                        child: Stack(
                          children: <Widget>[
                            // 현재 카메라 화면 확인
                            Positioned.fill(
                              child: CameraPreview(
                                controller!,
                                child: LayoutBuilder(builder:
                                    (BuildContext context,
                                        BoxConstraints constraints) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTapDown: (details) =>
                                        onViewFinderTap(details, constraints),
                                  );
                                }),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isCameraInitialized = false;
                                            });
                                            onNewCameraSelected(cameras[
                                                _isRearCameraSelected ? 1 : 0]);
                                            setState(() {
                                              _isRearCameraSelected =
                                                  !_isRearCameraSelected;
                                            });
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
                                                _isRearCameraSelected
                                                    ? Icons.camera_front
                                                    : Icons.camera_rear,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                        _isRecordingInProgress
                                            ? Container(
                                                height: 80,
                                                width: 160,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        if (controller!.value
                                                            .isRecordingPaused) {
                                                          await resumeVideoRecording();
                                                        } else {
                                                          await pauseVideoRecording();
                                                        }
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          controller!.value
                                                                  .isRecordingPaused
                                                              ? Icon(
                                                                  Icons
                                                                      .play_arrow_rounded,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 42,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .pause_rounded,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 42,
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        XFile? rawVideo =
                                                            await stopVideoRecording();
                                                        File videoFile = File(
                                                            rawVideo!.path);

                                                        int currentUnix = DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch;

                                                        final directory =
                                                            await getApplicationDocumentsDirectory();

                                                        String fileFormat =
                                                            videoFile.path
                                                                .split('.')
                                                                .last;

                                                        _videoFile =
                                                            await videoFile
                                                                .copy(
                                                          '${directory.path}/$currentUnix.$fileFormat',
                                                        );
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .square_rounded,
                                                            color: Colors.black,
                                                            size: 30,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await startVideoRecording();
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
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isCameraInitialized = false;
                                            });
                                            onNewCameraSelected(cameras[
                                                _isRearCameraSelected ? 1 : 0]);
                                            setState(() {
                                              _isRearCameraSelected =
                                                  !_isRearCameraSelected;
                                            });
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
                                                _isRearCameraSelected
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE0426F),
                    ),
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Text(
                    'Permission denied',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      getPermissionStatus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Give permission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
