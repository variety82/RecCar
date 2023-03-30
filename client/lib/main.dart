import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/calendar': (context) => Calendar(),
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
  dynamic userName = '';
  dynamic userProfileImg = '';
  dynamic userCarId = '';

  // dynamic userName = '';
  // dynamic userEmail = '';

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
    var name = await storage.read(key: 'nickName');
    var img = await storage.read(key: 'picture ');
    var carId = await storage.read(key: 'carId');
    setState(() {
      userName = name;
      userProfileImg = img;
      userCarId = carId;
    });
    if (userName == null) {
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
                const Text(
                  '대충 차고 이미지',
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text('차량 등록 아직 안했을 경우'),
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
                      Navigator.pushNamed(context, '/detail');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
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
