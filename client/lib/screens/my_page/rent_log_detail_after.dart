import 'package:flutter/material.dart';
import '../../widgets/my_page/damage_log_card.dart';

class AfterRent extends StatefulWidget {
  final dynamic after;

  const AfterRent({
    super.key,
    required this.after,
  });

  @override
  State<AfterRent> createState() => _AfterRentState();
}

class _AfterRentState extends State<AfterRent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                if (widget.after.length == 0)
                  Container(child: Text("손상 정보가 없습니다"),),
                if(widget.after.length != 0)
                  for (var info in widget.after)
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
