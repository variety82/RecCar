import 'package:flutter/material.dart';

class DamageCountInfoBlock extends StatelessWidget {
  final String damageName;
  final int damageCnt;

  const DamageCountInfoBlock({
    Key? key,
    required this.damageName,
    required this.damageCnt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: damageCnt == 0
              ? Theme.of(context).disabledColor
              : Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              damageName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              indent: 16,
              endIndent: 16,
              height: 24,
            ),
            Text(
              '${damageCnt}건',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: damageCnt == 0
                    ? Colors.black
                    : Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
