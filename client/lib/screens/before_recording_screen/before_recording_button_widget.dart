import 'package:flutter/material.dart';

// import screens
import 'package:client/screens/video_recording_screen/video_recording_screen.dart';
import 'package:client/screens/video_recording_screen/camera_screen.dart';

// MainButton widget으로 구현함
class BeforeRecordingButton extends StatelessWidget {
  final String text;

  const BeforeRecordingButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(200, 50),
          backgroundColor: Color(0xFFE0426F),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(),
              // builder: (context) => const VideoRecordingScreen(),
            ),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
