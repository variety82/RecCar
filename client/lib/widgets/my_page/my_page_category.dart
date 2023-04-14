import 'dart:io';

import 'package:client/services/my_page_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../screens/my_page/car_info.dart';
import '../../screens/my_page/rent_log.dart';
import '../../screens/my_page/alarm_setting.dart';
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
      return "회원 정보 초기화";
  }
}

class _MyPageCategoryState extends State<MyPageCategory> {
  static const storage = FlutterSecureStorage();
  String? userName;
  String? userProfileImg;

  FocusNode? _unUsedFocusNode;

  var _modifiedName;
  final TextEditingController _userNameController = TextEditingController();

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

  void modifyUser() {
    File file = File(_pickedImg.path);
    var path = file.path;
    // List<int> imageBytes = file.readAsBytesSync();
    // String base64Image = base64Encode(imageBytes);
    // Uint8List decodedbytes = base64.decode(base64Image);
    setState(() {
      _modifiedName = _userNameController.text;
    });
    patchUserInfo(
      success: (dynamic response) {
        print(response);
      },
      fail: (error) {
        print("사용자 수정 오류: $error");
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
      nickname: "$_modifiedName",
      profileImg: path,
    );
    logout();
  }

  Future<String?> setUserName() async {
    final userName = await storage.read(key: 'nickName');
    return userName;
  }

  Future<String?> setUserProfileImg() async {
    final userImg = await storage.read(key: 'picture');
    return userImg;
  }

  final ImagePicker _picker = ImagePicker();
  XFile _pickedImg = XFile("");

  logout() async {
    await storage.deleteAll();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    Navigator.pushNamed(context, '/login');
  }

  // checkUserState() async {
  //   // var id = await storage.read(key: 'id');
  //   var name = await storage.read(key: 'nickName');
  //   // var email = await storage.read(key: 'email');
  //   setState(() {
  //     // userId = id;
  //     userName = name;
  //     // userEmail = email;
  //   });
  //   if (userId == null) {
  //     Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(
            Size(MediaQuery.of(context).size.width, 50)),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        if (widget.category ==
            convertCategoryNameToKor(CategoryName.ModifyInfo)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   "프로필 변경",
                      //   style: TextStyle(
                      //     color: Theme.of(context).secondaryHeaderColor,
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {
                          _getPhotoLibraryImage();
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: const Color(0xFFD9D9D9), width: 2.5),
                            image: userProfileImg == ""
                                ? const DecorationImage(
                                    image: NetworkImage(
                                        "https://profileimg.plaync.com/account_profile_images/8A3BFAF2-D15F-E011-9A06-E61F135E992F?imageSize=large"))
                                : DecorationImage(
                                    image: FileImage(File(userProfileImg!)),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.zero,
                        child: TextButton(
                          onPressed: () {
                            _getPhotoLibraryImage();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_outlined,
                                  color: Color(0xFF6A6A6A)),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "사진 변경하기",
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _userNameController
                            ..text = userName ?? "",
                          onTapOutside: (PointerDownEvent event) {
                            FocusScope.of(context)
                                .requestFocus(_unUsedFocusNode);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 3),
                            isDense: true,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          modifyUser();
                        },
                        child: Text("수정하기",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      )
                    ],
                  ),
                ),
              );
            },
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MyDataModify()),
          // );
        } else if (widget.category ==
            convertCategoryNameToKor(CategoryName.MyCar)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarInfo()),
          );
        } else if (widget.category ==
            convertCategoryNameToKor(CategoryName.RentLog)) {
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
        } else if (widget.category ==
            convertCategoryNameToKor(CategoryName.Logout)) {
          logout();
        } else if (widget.category ==
            convertCategoryNameToKor(CategoryName.Resign)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$userName 님",
                        style: const TextStyle(
                          height: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "모든 렌트 내역 및 차량 파손 내역이 삭제됩니다.\n계속 진행하시겠습니까?",
                        style: TextStyle(height: 2),
                      ),
                      const SizedBox(height: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => {resignUser()},
                            child: Container(
                              width: 110,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFE0426F)),
                              child: const Text(
                                "확인",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: Container(
                              width: 110,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
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
                              child: const Text(
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
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        height: 30,
        child: Text(
          widget.category,
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

  void resignUser() {
    deleteUserInfo(
      success: (dynamic response) {},
      fail: (error) {
        print('사용자 정보 초기화 오류: $error');
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
    );
    Navigator.pop(context);
  }

  _getPhotoLibraryImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImg = pickedFile;
        storage.write(key: 'picture', value: File(_pickedImg.path).path);
      });
      await setUserProfileImg().then((value) {
        setState(() {
          userProfileImg = value;
        });
      });
    } else {
      print('이미지 선택안함');
    }
  }
}
