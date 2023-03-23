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
                for (int i = 0; i < widget.after.length; i++)
                  DamageLogCard(
                    imageUrl:
                    "${widget.after[i]['damageImageUrl']}",
                    kindOfDamage: "${widget.after[i]['damage']}",
                    damageLocation: "${widget.after[i]['part']}",
                    damageId: widget.after[i]['detectionInfoId'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
