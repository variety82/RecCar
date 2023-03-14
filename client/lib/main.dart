import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';
import 'screens/register/car_register_main.dart';
import 'screens/my_page/my_page.dart';
import 'screens/gas_station_search_page/gas_station_search.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'cilent',

        theme: ThemeData(fontFamily: 'Pretendard'),
        themeMode: ThemeMode.system,
        initialRoute: '/home',
        routes: {
          '/home': (context) => const MyApp(),
          '/register': (context) => const CarRegister(),
          '/my-page' : (context) => const MyPage(),
          '/station' : (context) => NaverMapTest(),
        },
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,
      body: Column(
        children: [
          const Header(
            title: 'Main',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Text('대충 차고 이미지'),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    icon: const Icon(Icons.add_box_rounded)
                ),
              ],
            ),
          ),
          const Footer()
        ],
      ),
    );
  }
}