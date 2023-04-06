import 'package:flutter/material.dart';

class RentLogLine extends StatelessWidget {
  final String infoTitle;
  final String info;
  final double space;

  const RentLogLine({
    super.key,
    required this.infoTitle,
    required this.info,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: space,
          child: Text(
            infoTitle,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 12,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          child: Text(
            info,
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 13,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
