import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';
import 'screens/register/car_register_main.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'cilent',
      theme: ThemeData(fontFamily: 'Pretendard'),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/register': (context) => const CarRegister(),
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
      home:Scaffold(
        backgroundColor: Colors.white ,
        body: Column(
          children: [
            const Header(
              title: 'Main',
            ),
            Expanded(
                child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        const Text('대충 차고 이미지'),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            icon: const Icon(Icons.add_box_rounded)),
                      ],
                  ),
            ),
            const Footer()
          ],
        ),
      ),
    );
  }
}