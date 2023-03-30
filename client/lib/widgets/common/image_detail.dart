import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  final String imageCase;

  const ImageDetailScreen({
    required this.imagePath,
    required this.imageCase,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '이미지 상세보기',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        // backgroundColor: Color(0xFFFF3F3F),
        backgroundColor: Colors.black38,
        foregroundColor: Color(0xFFFF3F3F),
      ),
      body: Center(
        child: Container(
          // 가로/세로 크기 화면 크기만큼 유용할 수 있도록 조정
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            // 감싸는 자식 위젯 넣어줌
            child: imageCase == 'url'
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  ),
            // 최대 확대, 최소 축소 비율을 각각 지정
            maxScale: 5.0,
            minScale: 0.1,
            // 이동, 확대/축소의 한계선과 뷰포트 경계 사이의 픽셀 여백 지정
            boundaryMargin: EdgeInsets.all(20),
            // 두 손 스크롤 시 확대/축소 가능하게 함
            scaleEnabled: true,
            // 한 손가락으로 스크롤 가능하도록 지정함
            panEnabled: true,
          ),
        ),
      ),
    );
  }
}
