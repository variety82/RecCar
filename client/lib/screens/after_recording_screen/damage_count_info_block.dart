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
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFFFBD5DC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              damageName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
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
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF3F3F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
