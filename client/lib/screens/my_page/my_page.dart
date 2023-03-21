import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/my_page_category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  XFile? profileImg;
  static final storage = FlutterSecureStorage();
  dynamic userId = '';
  dynamic userName = '';
  dynamic userEmail = '';
  dynamic userProfileImg = '';

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  checkUserState() async {
    var id = await storage.read(key: 'id');
    var name = await storage.read(key: 'name');
    var email = await storage.read(key: 'email');
    var img = await storage.read(key: 'profileImg');
    setState(() {
      userId = id;
      userName = name;
      userEmail = email;
      userProfileImg = img;
    });
    if (userId == null) {
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Header(
            title: '마이 페이지',
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 마이페이지에 들어갈 UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 프로필 사진 Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(userProfileImg==null?
                                "https://profileimg.plaync.com/account_profile_images/8A3BFAF2-D15F-E011-9A06-E61F135E992F?imageSize=large":userProfileImg.toString())),
                      ),
                    ),
                    // 이메일 및 프로필 편집 버튼 Container
                    Container(
                      // width: 250,
                      height: 100,
                      margin: EdgeInsets.only(left: 27),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 이메일 출력
                            Text(
                              "${userName}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none),
                            ),

                            // 간격
                            SizedBox(
                              height: 5,
                            ),
                            // 프로필 편집 버튼 Container
                            Container(
                              child: TextButton(
                                onPressed: () => {
                                  _getPhotoLibraryImage()
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext) {
                                  //       return Dialog();
                                  //     })
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "⚙ 프로필 편집",
                                    style: TextStyle(
                                        color: Color(0xFF6A6A6A),
                                        fontSize: 13,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),

                // User 프로필과 메뉴를 가르는 Divider
                const Divider(
                  height: 40,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Color(0xFFD8D8D8),
                ),

                // 메뉴 카테고리
                MyPageCategory(category: "내 정보 수정", textColor: Colors.black),
                MyPageCategory(category: "차량 정보 조회", textColor: Colors.black),
                MyPageCategory(category: "렌트 내역", textColor: Colors.black),
                MyPageCategory(category: "알림 설정", textColor: Colors.black),
                MyPageCategory(category: "로그아웃", textColor: Colors.black),
                MyPageCategory(category: "회원 탈퇴", textColor: Colors.red),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
  
  // 프로필 사진 변경하는 메소드
  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
    print("HEY!!!!!${pickedFile.path}");
    storage.write(key: 'profileImg', value: pickedFile.path);

    } else {
      print('이미지 선택안함');
    }
  }
}
