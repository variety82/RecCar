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
                for (int i = 0; i < widget.before.length; i++)
                  DamageLogCard(
                    imageUrl:
                        "${widget.before[i]['damageImageUrl']}",
                    kindOfDamage: "${widget.before[i]['damage']}",
                    damageLocation: "${widget.before[i]['part']}",
                    damageId: widget.before[i]['detectionInfoId'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
