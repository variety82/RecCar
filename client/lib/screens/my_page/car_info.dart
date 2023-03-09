import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';

class CarInfo extends StatelessWidget {
  const CarInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Header(
            title: '차량 정보 조회',
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
