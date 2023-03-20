import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // flutter_secure_storage 패키지

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static final storage =
      FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'id');
    if (userInfo != null) {
      Navigator.pushNamed(context, '/home');
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://cdn.dribbble.com/users/2374064/screenshots/4732016/car-jump.gif"),
          fit: BoxFit.fill,
        ),
      ),
      padding: EdgeInsets.only(bottom: 100),
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: loginWithGoogle,
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 10),
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
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://w7.pngwing.com/pngs/869/485/png-transparent-google-logo-computer-icons-google-text-logo-google-logo-thumbnail.png")),
                ),
              ),
              SizedBox(width: 15),
              Text(
                "Login with Google",
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      await storage.write(
        key: 'name',
        value: googleUser.displayName,
      );
      await storage.write(
        key: 'email',
        value: googleUser.email,
      );
      await storage.write(
        key: 'id',
        value: googleUser.id,
      );
      await storage.write(
        key: 'profileImg',
        value: googleUser.photoUrl,
      );
      Navigator.pushNamed(context, '/home');
    }
  }
}
