import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:client/screens/check_video_screen/check_video_screen.dart';

// Stateful Widget 생성
class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  // state 생성
  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

// State part
class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  // 앱 시작 시, 후면 카메라를 미리 볼 수 있음
  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  // 카메라 작동 안할 시, 메모리 해제
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // camera 초기 설정
  _initCamera() async {
    // 먼저 현재 기기 내에서 사용 가능한 카메라 목록을 전부 불러옴
    final cameras = await availableCameras();
    print(cameras);
    // // 전면 카메라 선택
    // final front = cameras.firstWhere(
    //     (camera) => camera.lensDirection == CameraLensDirection.front);
    // 후면 카메라 선택
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    // 후면 카메라를 선택한 후, 영상 해상도를 최대로 선택함
    _cameraController = CameraController(back, ResolutionPreset.max);
    // 컨트롤러를 초기화함
    await _cameraController.initialize();
    // 로딩 종료함
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CheckVideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  // UI part
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE0426F),
          ),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
