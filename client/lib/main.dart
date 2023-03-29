import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';
import 'screens/register/car_register_main.dart';
import 'screens/my_page/my_page.dart';
import 'screens/gas_station_search_page/gas_station_search.dart';
import 'screens/before_recording_screen/before_recording_screen.dart';
import 'screens/video_recording_screen/camera_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/detail/car_detail.dart';
import 'screens/calendar_screen/calendar_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(
    MaterialApp(
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
        '/login': (context) => const Login(),
        '/before-recording': (context) => const BeforeRecordingScreen(),
        '/recording': (context) => CameraScreen(),
        '/calendar': (context) => const Calendar(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const storage = FlutterSecureStorage();
  dynamic userId = '';
  dynamic userName = '';
  dynamic userEmail = '';

  @override
  void initState() {
    super.initState();
    // checkUserState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  checkUserState() async {
    var id = await storage.read(key: 'id');
    var name = await storage.read(key: 'name');
    var email = await storage.read(key: 'email');
    setState(() {
      userId = id;
      userName = name;
      userEmail = email;
    });

    if (userId == null) {
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    }
  }

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
                Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'lib/assets/images/empty_garage.svg',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 180,
                      ),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            icon: const Icon(Icons.add_box_rounded)),
                      ),
                    ),
                  ]
                ),
                const SizedBox(
                  height: 100,
                ),

                const Text(
                  '차량 등록됐을 경우',
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detail');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor
                    ),
                    child: const Text('차량 상세 페이지'))
              ],
            ),
          ),
          const Footer()
        ],
      ),
    );
  }
}
