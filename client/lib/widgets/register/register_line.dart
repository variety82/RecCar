import 'package:flutter/material.dart';

class registerLine extends StatelessWidget {
  final String category;
  final String? content;
  final bool isLastLine;


  const registerLine({
    super.key, required this.category, required this.content, required this.isLastLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  category,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999)
                  ),
                ),
              ),
              Text(
                content ?? '',
                style: const TextStyle(
                    color: Color(0xFF453F52)
                ),
              ),

            ],
          ),
        ),

        Offstage(
          offstage: isLastLine,
          child: Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFEFEFEF),
          ),
        )
      ],
    );
  }
}