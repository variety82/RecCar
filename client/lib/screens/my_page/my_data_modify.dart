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
            child: Column(),
          ),
          Footer(),
        ],
      ),
    );
  }
}
