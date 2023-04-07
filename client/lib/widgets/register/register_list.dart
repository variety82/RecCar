import 'package:flutter/material.dart';

class RegisterList extends StatelessWidget {

  final List<Widget> lineList;

  const RegisterList({
    super.key, required this.lineList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF999999).withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 6,
            )
          ]
      ),
      width: double.infinity,
      child: Column(
        children: lineList
      ),
    );
  }
}




