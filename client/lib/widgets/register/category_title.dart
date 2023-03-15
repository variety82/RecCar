import 'package:flutter/material.dart';


class CategoryTitle extends StatelessWidget {

  final String title;
  final bool isSelected;

  const CategoryTitle({
    super.key, required this.title, required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width : 80,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ?  const Color(0xFF453F52) : const Color(0xFF999999),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500
        ),
      ),
    );
  }
}