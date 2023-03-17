import 'package:flutter/material.dart';
import '../../screens/my_page/my_data_modify.dart';
import '../../screens/my_page/car_info.dart';
import '../../screens/my_page/rent_log.dart';
import '../../screens/my_page/alarm_setting.dart';

class MyPageCategory extends StatelessWidget {
  final String category;
  final Color textColor;

  const MyPageCategory({
    super.key,
    required this.category,
    required this.textColor,
  });

  void clickCategory(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyDataModify()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (category == "내 정보 수정") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyDataModify()),
          );
        } else if (category == "차량 정보 조회") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarInfo()),
          );
        } else if (category == "렌트 내역") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RentLog()),
          );
        } else if (category == "알림 설정") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlarmSetting()),
          );
        } else if (category == "회원 탈퇴") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  height: 190,
                  padding: EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "songheew1020@gmail.com 님,",
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
                      SizedBox(height: 5),
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
          vertical: 10,
        ),
        height: 40,
        child: Text(
          "$category",
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
