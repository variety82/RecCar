import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/detail/damage_level_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {

  int sideDamageLevel = 4;
  int frontDamageLevel = 2;
  int backDamageLevel = 1;
  int wheelDamageLevel = 1;

  FlutterSecureStorage storage = const FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    // getDamageInfo()
    var carId = storage.read(key: 'carId');

    print(carId);

  }

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
            child: SingleChildScrollView(
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
                    'lib/assets/images/car_damage_img/car_f${frontDamageLevel}_s${sideDamageLevel}_b${backDamageLevel}_w$wheelDamageLevel.svg',
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
                  DamageLevelCard(
                    damageLevel: frontDamageLevel,
                    partName: '앞펜더 / 앞범퍼 / 전조등'
                  ),
                  DamageLevelCard(
                      damageLevel: sideDamageLevel,
                      partName: '옆면 / 사이드 / 스텝'
                  ),
                  DamageLevelCard(
                      damageLevel: backDamageLevel,
                      partName: '뒷펜더 / 뒷범퍼 / 후미등'
                  ),
                  DamageLevelCard(
                      damageLevel: wheelDamageLevel,
                      partName: '타이얼 / 휠'
                  ),
                ],
              ),
            ),
          ),
          ),
          const Footer()
        ],
      )
    );
  }
}


