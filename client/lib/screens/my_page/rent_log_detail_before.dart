import 'package:flutter/material.dart';
import '../../widgets/my_page/damage_log_card.dart';

class BeforeRent extends StatelessWidget {
  final int id;

  const BeforeRent({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                for (int i = 0; i < 7; i++)
                  DamageLogCard(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLF9LLlP2p2PEAlUdOMIc_5fuqi6wh15ch7A&usqp=CAU",
                    kindOfDamage: "스크래치",
                    damageLocation: "범퍼",
                    id: i,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
