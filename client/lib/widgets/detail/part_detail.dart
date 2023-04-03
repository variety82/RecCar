import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/detail/damage_level_card.dart';
import 'package:client/widgets/common/footer.dart';

class partDetail extends StatelessWidget {
  const partDetail({
    super.key,
    required this.frontDamageLevel,
    required this.sideDamageLevel,
    required this.backDamageLevel,
    required this.wheelDamageLevel,
  });

  final int frontDamageLevel;
  final int sideDamageLevel;
  final int backDamageLevel;
  final int wheelDamageLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}