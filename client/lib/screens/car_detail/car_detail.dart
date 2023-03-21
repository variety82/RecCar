import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/detail/damage_level_card.dart';


class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {

  int sideDamageLevel = 2;
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
            title: '차량 상세 정보'
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'SM5',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SvgPicture.asset(
                  'lib/assets/car_damage_img/car_f${frontDamageLevel}_s${sideDamageLevel}_b${backDamageLevel}_w$wheelDamageLevel.svg',
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '손상 부위',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                DamageLevelCard(sideDamageLevel: sideDamageLevel),

              ],
            ),
          ),
          ),
          const Footer()
        ],
      )
    );
  }
}


