import 'dart:io';
import 'package:client/services/my_page_api.dart';
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
  String? userName;
  String? userProfileImg;

  @override
  void initState() {
    setUserName().then((value) {
      setState(() {
        userName = value;
      });
    });
    setUserProfileImg().then((value) {
      setState(() {
        userProfileImg = value;
      });
    });

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setUser();
    // });
  }

  Future<String?> setUserName() async {
    final userName = await storage.read(key: 'nickName');
    return userName;
  }

  Future<String?> setUserProfileImg() async {
    final userImg = await storage.read(key: 'picture');
    return userImg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // 프로필 사진 Container
              Container(
                height: 200,
                width: 5000,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                top: 150,
                left: 10,
                right: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 280,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2.5),
                      color: Colors.white,
                      image: userProfileImg == ""
                          ? DecorationImage(
                              image: NetworkImage(
                                  "https://profileimg.plaync.com/account_profile_images/8A3BFAF2-D15F-E011-9A06-E61F135E992F?imageSize=large"))
                          : DecorationImage(
                              image: FileImage(File(userProfileImg!)),
                              // image: DecorationImage(
                              //   image: NetworkImage(
                              //     "${userProfileImg}" == ""
                              //         ? "https://profileimg.plaync.com/account_profile_images/8A3BFAF2-D15F-E011-9A06-E61F135E992F?imageSize=large"
                              //         : userProfileImg.toString(),
                              //   ),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                top: 100,
                left: 50,
                right: 50,
              ),
              Positioned(
                top: 225,
                left: 50,
                right: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${userName}",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              // Visibility(
              //   visible: true,
              //   child: Positioned(
              //     child: Card(
              //       child: InkWell(
              //         child: Text(
              //           "프로필 편집",
              //           style: TextStyle(
              //             color: Theme.of(context).primaryColor,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         onTap: () {
              //           // print("HI");
              //           showDialog(context: context, builder: (BuildContext context) {
              //             return Dialog(
              //               child: Text("HI"),
              //             );
              //           });
              //         },
              //       ),
              //     ),
              //     top: 240,
              //     left: 50,
              //     right: 50,
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "내 정보 수정",
                      textColor: Theme.of(context).secondaryHeaderColor),
                ),
                // 메뉴 카테고리
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "차량 정보 조회",
                      textColor: Theme.of(context).secondaryHeaderColor),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "렌트 내역",
                      textColor: Theme.of(context).secondaryHeaderColor),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "알림 설정",
                      textColor: Theme.of(context).secondaryHeaderColor),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "로그아웃",
                      textColor: Theme.of(context).secondaryHeaderColor),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyPageCategory(
                      category: "회원 정보 초기화",
                      textColor: Theme.of(context).primaryColor),
                ),
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
      // storage.write(key: 'profileImg', value: pickedFile.path);
    } else {
      print('이미지 선택안함');
    }
  }
}
