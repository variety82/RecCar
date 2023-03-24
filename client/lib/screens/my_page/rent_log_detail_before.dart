import 'package:flutter/material.dart';
import '../../widgets/my_page/damage_log_card.dart';

class BeforeRent extends StatefulWidget {
  final dynamic before;

  const BeforeRent({
    super.key,
    required this.before,
  });

  @override
  State<BeforeRent> createState() => _BeforeRentState();
}

class _BeforeRentState extends State<BeforeRent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                if (widget.before.length == 0)
                  Container(child: Text("손상 정보가 없습니다"),),
                if (widget.before.length != 0)
                  for (var info in widget.before)
                    DamageLogCard(
                      imageUrl:
                          "${info['damageImageUrl']}",
                      kindOfDamage: "${info['damage']}",
                      damageLocation: "${info['part']}",
                      damageId: info['detectionInfoId'],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
