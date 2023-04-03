import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/detail/damage_level_card.dart';
import 'package:client/widgets/common/footer.dart';

class partDetail extends StatelessWidget {

  final Map<String, dynamic>? detectionInfos;

  const partDetail({
    super.key, required this.detectionInfos,
  });

  @override
  Widget build(BuildContext context) {

    List<dynamic> frontDamageList = detectionInfos?['front'] ?? [];
    List<dynamic> sideDamageList = detectionInfos?['side'] ?? [];
    List<dynamic> backDamageList = detectionInfos?['back'] ?? [];
    List<dynamic> wheelDamageList = detectionInfos?['wheel'] ?? [];

    int frontDamageCount = frontDamageList.length;
    int sideDamageCount = sideDamageList.length;
    int backDamageCount = backDamageList.length;
    int wheelDamageCount = wheelDamageList.length;

    int evaluateDamageLevel(int damageCount) {
      if (damageCount == 0) {
        return 0;
      } else if (damageCount <= 2) {
        return 1;
      } else if (damageCount <= 4) {
        return 2;
      } else if (damageCount <= 6) {
        return 3;
      } else {
        return 4;
      }
    }

    int frontDamageLevel = evaluateDamageLevel(frontDamageCount);
    int sideDamageLevel = evaluateDamageLevel(sideDamageCount);
    int backDamageLevel = evaluateDamageLevel(backDamageCount);
    int wheelDamageLevel = evaluateDamageLevel(wheelDamageCount);

    return Column(
      children: [
        // const Header(
        //     title: '차량 상세 정보'
        // ),
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
                  damageLevel: frontDamageCount,
                  partName: '앞펜더 / 앞범퍼 / 전조등',
                  damageList: frontDamageList,
                ),
                DamageLevelCard(
                  damageLevel: sideDamageCount,
                  partName: '옆면 / 사이드 / 스텝',
                  damageList: sideDamageList,
                ),
                DamageLevelCard(
                  damageLevel: backDamageCount,
                  partName: '뒷펜더 / 뒷범퍼 / 후미등',
                  damageList: backDamageList,
                ),
                DamageLevelCard(
                  damageLevel: wheelDamageCount,
                  partName: '타이얼 / 휠',
                  damageList: wheelDamageList,
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