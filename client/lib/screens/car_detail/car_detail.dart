import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {

  int sideDamageLevel = 3;
  int frontDamageLevel = 1;
  int backDamageLevel = 2;
  int wheelDamageLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Header(
            title: '차량 상세'
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  'lib/assets/car_damage_img/car_f${frontDamageLevel}_s${sideDamageLevel}_b${backDamageLevel}_w$wheelDamageLevel.svg',
                ),
                Text('측면 $sideDamageLevel건'),
                Text('전면부 $frontDamageLevel건'),
                Text('후면부 $backDamageLevel건'),
                Text('타이어 $wheelDamageLevel건'),

              ]
            ),
          )),
          const Footer()
        ],
      )
    );
  }
}
