import 'package:client/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'screens/register/car_register_main.dart';
import 'screens/my_page/my_page.dart';
import 'screens/map_screen/map_screen.dart';
import 'screens/before_recording_screen/before_recording_screen.dart';
import 'package:client/screens/video_recording_screen/video_recording_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/detail/car_detail.dart';
import 'screens/calendar_screen/calendar_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home/home.dart';

void main() async {
  // 앱 처음 실행 시 flutter 엔진 초기화 메소드 호출
  // flutter 자체의 렌더링 엔진을 사용할 때 필요한 기본적인 설정들을 수행하는 메소드라고 생각하면 됨
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  // 앱 처음 실행 시 flutter 엔진 초기화 메소드 호출
  // flutter 자체의 렌더링 엔진을 사용할 때 필요한 기본적인 설정들을 수행하는 메소드라고 생각하면 됨
  // 세로 방향으로 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        // scratchColor: const Color.fromRGBO(240, 15, 135, 1),
        // crushedColor: const Color.fromRGBO(64, 64, 64, 1),
        // breakageColor: const Color.fromRGBO(250, 150, 200, 1),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const Home(),
        '/register': (context) => const CarRegister(),
        '/detail': (context) => const CarDetail(),
        '/my-page': (context) => const MyPage(),
        '/station': (context) => NaverMapTest(),
        '/login': (context) => const Login(),
        '/before-recording': (context) => const BeforeRecordingScreen(),
        '/recording': (context) => const VideoRecordingScreen(),
        '/calendar': (context) => const Calendar(),
      },
    ),
  );
}
