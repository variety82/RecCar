import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/screens/after_recording_screen/after_recording_screen.dart';

class BeforeRecordingConfirmScreen extends StatelessWidget {
  String? videoFilePath;
  File? videoFile;

  Future<void> _pickVideo(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile = File(pickedFile.path);
      videoFilePath = videoFile!.path;
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AfterRecordingScreen(
          filePath: videoFilePath!,
        ),
      );
      Navigator.pop(context);
      Navigator.push(context, route);
    }
  }

  Future<void> _takeVideo(BuildContext context) async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      await Future.delayed(Duration(seconds: 3));
      videoFile = File(pickedFile.path);
      videoFilePath = videoFile!.path;
      if (videoFilePath != null) {
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AfterRecordingScreen(
            filePath: videoFilePath!,
          ),
        );
        Navigator.pop(context);
        Navigator.push(context, route);
      }
    }
  }

  // void _showImagePicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: [
  //             ListTile(
  //               leading: Icon(Icons.photo_library),
  //               title: Text('사진 선택'),
  //               onTap: () {
  //                 _pickImage();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             // 다른 이미지 선택 옵션 추가 가능
  //             ListTile(
  //               leading: Icon(Icons.camera_alt),
  //               title: Text('사진 찍기'),
  //               onTap: () {
  //                 _takeImage();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor는 흰색으로 설정
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFFFF3F3F),
        ),
        // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // 상하 간격
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Wrap(
                      // 세로로 나열
                      direction: Axis.vertical,
                      // 나열 방향
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // 정렬 방식
                      spacing: 10,
                      // 좌우 간격
                      children: [
                        Text(
                          '지금부터',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF453F52),
                          ),
                        ),
                        Text(
                          '녹화가 시작됩니다.',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF453F52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '선택해주세요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 50),
                              backgroundColor: Color(0xFFE0426F),
                            ),
                            onPressed: () {
                              _pickVideo(context);
                            },
                            child: Text(
                              '갤러리에서 선택하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 50),
                              backgroundColor: Color(0xFFE0426F),
                            ),
                            onPressed: () {
                              _takeVideo(context);
                            },
                            child: Text(
                              '새로운 영상 촬영하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
