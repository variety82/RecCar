import 'dart:math';

import 'package:flutter/material.dart';
import '../../screens/my_page/my_data_modify.dart';
import '../../screens/my_page/car_info.dart';
import '../../screens/my_page/rent_log.dart';
import '../../screens/my_page/alarm_setting.dart';
import '../../screens/login_screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyPageCategory extends StatefulWidget {
  final String category;
  final Color textColor;

  const MyPageCategory({
    super.key,
    required this.category,
    required this.textColor,
  });

  @override
  State<MyPageCategory> createState() => _MyPageCategoryState();
}

enum CategoryName { ModifyInfo, MyCar, RentLog, NoticeSetting, Logout, Resign }

String convertCategoryNameToKor(CategoryName name) {
  switch (name) {
    case CategoryName.ModifyInfo:
      return "내 정보 수정";
    case CategoryName.MyCar:
      return "차량 정보 조회";
    case CategoryName.RentLog:
      return "렌트 내역";
    case CategoryName.NoticeSetting:
      return "알림 설정";
    case CategoryName.Logout:
      return "로그아웃";
    case CategoryName.Resign:
      return "회원 탈퇴";
  }
}

class _MyPageCategoryState extends State<MyPageCategory> {
  // void clickCategory(context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const MyDataModify()),
  //   );
  // }
  static final storage = FlutterSecureStorage();
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

  logout() async {
    await storage.deleteAll();
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    _googleSignIn.signOut();
    Navigator.pushNamed(context, '/login');
  }

  checkUserState() async {
    var id = await storage.read(key: 'id');
    var name = await storage.read(key: 'name');
    var email = await storage.read(key: 'email');
    setState(() {
      // userId = id;
      userName = name;
      // userEmail = email;
    });
    if (userId == null) {
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.category ==
            convertCategoryNameToKor(CategoryName.ModifyInfo)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyDataModify()),
          );
        } else
        if (widget.category == convertCategoryNameToKor(CategoryName.MyCar)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarInfo()),
          );
        } else
        if (widget.category == convertCategoryNameToKor(CategoryName.RentLog)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RentLog()),
          );
        } else if (widget.category ==
            convertCategoryNameToKor(CategoryName.NoticeSetting)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlarmSetting()),
          );
        } else
        if (widget.category == convertCategoryNameToKor(CategoryName.Logout)) {
          logout();
        }
        else
        if (widget.category == convertCategoryNameToKor(CategoryName.Resign)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  height: 190,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userName} 님",
                        style: TextStyle(
                          height: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "모든 렌트 내역 및 차량 파손 내역이 삭제됩니다.\n그래도 탈퇴하시겠습니까?",
                        style: TextStyle(height: 2),
                      ),
                      SizedBox(height: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => {},
                            child: Container(
                              width: 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFE0426F)),
                              child: Text(
                                "확인",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => {},
                            child: Container(
                              width: 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                  )
                                ],
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  color: Color(0xFF453F52),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        height: 30,
        child: Text(
          "${widget.category}",
          style: TextStyle(
            color: widget.textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
