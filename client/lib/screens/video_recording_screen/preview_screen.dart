import 'dart:io';

import 'package:flutter/material.dart';
import 'package:client/screens/video_recording_screen/captures_screen.dart';

class PreviewScreen extends StatelessWidget {
  final File imageFile;
  final List<File> fileList;

  const PreviewScreen({
    required this.imageFile,
    required this.fileList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CapturesScreen(
                      imageFileList: fileList,
                    ),
                  ),
                );
              },
              child: Text('Go to all captures'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Image.file(imageFile),
          ),
        ],
      ),
    );
  }
}
