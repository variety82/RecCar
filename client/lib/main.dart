import 'package:flutter/material.dart';
import 'package:client/screens/before_recording_screen/before_recording_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: 'TEST',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BeforeRecordingScreen()),
            );
          },
        ),
      ),
    );
  }
}
