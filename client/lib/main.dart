import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'cilent',
      theme: ThemeData(fontFamily: 'Pretendard'),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
      },
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const Scaffold(
        backgroundColor: Colors.white ,
        body: Column(
          children: [
            Header(
              title: 'Main',
            ),
            Expanded(child: Center(child: Text('대충 차고 이미지'),)),
            Footer()
          ],
        ),
      ),
    );
  }
}