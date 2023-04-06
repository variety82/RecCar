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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
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
        child: Stack(
          children: [
            Positioned.fill(child:  Container(
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
            ),),
            Positioned(top: 12, left: (MediaQuery.of(context).size.width / 2) - 160, child: Container(
              height: 40,
              width: 320,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: const Color(0xFF999999).withOpacity(0.5),
                  spreadRadius: 0.3,
                  blurRadius: 6,
                )
              ],
                borderRadius: BorderRadius.circular(20),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Icon(Icons.circle, size: 16, color: Color.fromRGBO(240, 15, 135, 0.75),), SizedBox(width: 4,),Text('스크래치', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500 ,color: Color.fromRGBO(240, 15, 135, 0.75),),)],),Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Icon(Icons.circle, size: 16, color: Color.fromRGBO(64, 64, 64, 0.75),), SizedBox(width: 4,),Text('찌그러짐', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500 ,color: Color.fromRGBO(64, 64, 64, 0.75),),)],),Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Icon(Icons.circle, size: 16, color: Color.fromRGBO(75, 150, 200, 0.75),), SizedBox(width: 4,),Text('파손', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500 ,color: Color.fromRGBO(75, 150, 200, 0.75),),)],),],
              ),
            ))
          ]
        ),
      ),
    );
  }
}
