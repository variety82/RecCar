import 'package:flutter/material.dart';

class MyPageCategory extends StatelessWidget {
  final String category;
  final Color textColor;

  const MyPageCategory({
    super.key,
    required this.category,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        height: 50,
        child: Text(
          "$category",
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
      );
  }
}
