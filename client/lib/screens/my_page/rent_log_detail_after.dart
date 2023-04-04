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
                      kindOfDamage: (info['scratch'] > 0 ? "스크래치 ":"") + (info['breakage'] > 0 ? "파손 " : "") + (info['crushed'] > 0 ? "찌그러짐 " : "") + (info['separated'] > 0 ? "이격 " : ""),
                      damageDate: "${info['damageDate']}",
                      damageLocation: "${info['part']}",
                      damageId: info['detectionInfoId'],
                      memo: info['memo'],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
