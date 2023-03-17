import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';
import 'screens/register/car_register_main.dart';
import 'screens/my_page/my_page.dart';
import 'screens/gas_station_search_page/gas_station_search.dart';
import 'screens/before_recording_screen/before_recording_screen.dart';
import 'screens/car_detail/car_detail.dart';

void main() {
  runApp(MaterialApp(
    title: 'cilent',
    theme: ThemeData(
      fontFamily: 'Pretendard',
      primaryColor: const Color(0xFFE0426F),
      primaryColorLight: const Color(0xFFFBD5DC),
      secondaryHeaderColor: const Color(0xFF453F52),
      shadowColor: const Color(0xFFEFEFEF),
      disabledColor: const Color(0xFF999999),
    ),
    themeMode: ThemeMode.system,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const MyApp(),
      '/register': (context) => const CarRegister(),
      '/detail': (context) => const CarDetail(),
      '/my-page': (context) => const MyPage(),
      '/station': (context) => NaverMapTest(),
      '/before-recording': (context) => const BeforeRecordingScreen(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Header(
            title: 'Main',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '대충 차고 이미지',
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  '차량 등록 아직 안했을 경우'
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    icon: const Icon(Icons.add_box_rounded)),
                const Text(
                  '차량 등록됐을 경우',
                ),
                ElevatedButton(
                    onPressed: () {
                      print(1);
                      Navigator.pushNamed(context, '/detail');
                    },
                    child: const Text(
                      '차량 상세 페이지'
                    ))
              ],
            ),
          ),
          const Footer()
        ],
      ),
    );
  }
}
