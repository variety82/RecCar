import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';

class MyDataModify extends StatelessWidget {
  const MyDataModify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Header(
            title: '내 정보 수정',
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "user 정보가 뭐뭐 있는지 모르곘어서 비워둡니당",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
