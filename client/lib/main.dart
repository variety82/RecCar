import 'package:flutter/material.dart';
import 'widgets/common/header.dart';
import 'widgets/common/footer.dart';
import 'screens/register/car_register_main.dart';
import 'screens/my_page/my_page.dart';
import 'screens/gas_station_search_page/gas_station_search.dart';
import 'screens/before_recording_screen/before_recording_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      '/my-page': (context) => const MyPage(),
      '/station': (context) => NaverMapTest(),
      '/before-recording': (context) => BeforeRecordingScreen(),
      '/login': (context) => Login(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final storage = FlutterSecureStorage();
  dynamic userId = '';
  dynamic userName = '';
  dynamic userEmail = '';

  @override
  void initState() {
    super.initState();

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
      print('로그인 페이지로 이동');
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    } else {
      print('${userName}님 환영합니다!');
      print('${userEmail}님 환영합니다!');
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
                const Text(
                  '대충 차고 이미지',
                ),
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
    );
  }
}
