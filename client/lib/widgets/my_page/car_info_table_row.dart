import 'package:flutter/material.dart';

class CarInfoTableRow extends StatelessWidget {
  final String rowName;
  final String rowInfo;

  const CarInfoTableRow({
    super.key,
    required this.rowName,
    required this.rowInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$rowName",
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 15,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(-50, 0),
              child: Text(
                "$rowInfo",
                style: TextStyle(
                  color: Color(0xFF453F52),
                  fontSize: 15,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
