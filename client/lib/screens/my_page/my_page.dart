import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/my_page_category.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

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
            height: 40,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 마이페이지에 들어갈 UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 프로필 사진 Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://profileimg.plaync.com/account_profile_images/8A3BFAF2-D15F-E011-9A06-E61F135E992F?imageSize=large")),
                      ),
                    ),

                    // 이메일 및 프로필 편집 버튼 Container
                    Container(
                      width: 250,
                      height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 이메일 출력
                            Text(
                              "songheew1020@gmail.com",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  decoration: TextDecoration.none),
                            ),

                            // 간격
                            SizedBox(
                              height: 15,
                            ),

                            // 프로필 편집 버튼 Container
                            Container(
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
                                  )
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
                          ]),
                    ),
                  ],
                ),

                // User 프로필과 메뉴를 가르는 Divider
                const Divider(
                  height: 50,
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
}
