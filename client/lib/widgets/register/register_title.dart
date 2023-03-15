import 'package:flutter/material.dart';


class RegisterTitle extends StatelessWidget {
  final String title;

  const RegisterTitle({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8,
            vertical: 20
          ),
          child:
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF453F52),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}