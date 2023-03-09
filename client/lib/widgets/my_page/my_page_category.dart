import 'package:flutter/material.dart';
import '../../screens/my_page/my_data_modify.dart';
import '../../screens/my_page/car_info.dart';
import '../../screens/my_page/rent_log.dart';

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
