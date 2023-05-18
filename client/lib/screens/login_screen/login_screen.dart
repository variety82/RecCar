import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // flutter_secure_storage 패키지
import '../../services/login_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const storage =
      FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  // dynamic userName = ''; // storage에 있는 유저 정보를 저장
  Map<String, dynamic> userInfo = {};

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Center 위젯 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment 설정
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: statusBarHeight,
            ),
            SvgPicture.asset(
              'lib/assets/images/logo/reccar_logo_vertical.svg',
              width: 150,
            ),
            const SizedBox(height: 150), // 간격 추가
            TextButton(
              onPressed: signIn,
              child: Container(
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://w7.pngwing.com/pngs/869/485/png-transparent-google-logo-computer-icons-google-text-logo-google-logo-thumbnail.png")),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "구글로 시작하기",
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '©2023 VALUEUP.',
              style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await user!.authentication;
    final credential = gAuth.accessToken;

    if (user == null) {
      //
    } else {
      await storage.write(
        key: "accessToken",
        value: credential,
      );
      login(
        success: (dynamic response) async {
          userInfo = response;
          await storage.write(key: "nickName", value: userInfo['nickName']);
          await storage.write(key: "picture", value: userInfo['picture']);
          await storage.write(
              key: "carId", value: userInfo['currentCarId'].toString());
          await storage.write(
              key: "carVideoState",
              value: userInfo['currentCarVideo'].toString());
          setState(() {});
          Navigator.pushNamed(context, '/home');
        },
        fail: (error) {
          print('로그인 호출 오류: $error');
        },
      );
    }
  }
}
