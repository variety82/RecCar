import 'package:flutter/material.dart';


class MakerItem extends StatelessWidget {
  final String makerTitle;
  final String makerImageUrl;

  const MakerItem({
    super.key, required this.makerTitle, required this.makerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFEFEFEF),
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(makerImageUrl),
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            makerTitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}