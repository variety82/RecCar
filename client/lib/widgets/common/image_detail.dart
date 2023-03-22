import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('이미지 상세보기'),
        elevation: 0,
        backgroundColor: Color(0xFFFF3F3F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: RotatedBox(
          quarterTurns: 0,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
            maxScale: 5.0,
            minScale: 0.1,
            boundaryMargin: EdgeInsets.all(20),
            scaleEnabled: true,
            panEnabled: true,
          ),
        ),
      ),
    );
  }
}
