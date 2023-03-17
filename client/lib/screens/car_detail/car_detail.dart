import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';

class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  @override

  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(
            title: '차량 상세'
          ),
          Expanded(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('자동차 이미지')
              ]
            ),
          )),
          Footer()
        ],
      )
    );
  }
}
