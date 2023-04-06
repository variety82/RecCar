import 'package:flutter/material.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_screen.dart';

// MoveButton widget으로 구현함
class MoveableButton extends StatelessWidget {
  final String text;
  final String routing;

  const MoveableButton({
    Key? key,
    required this.text,
    required this.routing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(200, 50),
        backgroundColor: Color(0xFFE0426F),
      ),
      onPressed: () {
        Navigator.pushNamed(context, routing);
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
