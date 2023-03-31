import 'package:flutter/material.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_screen.dart';

// MoveButton widget으로 구현함
class MoveableButton extends StatelessWidget {
  final String text;
  final String routing;
  final List<Map<String, dynamic>>? carDamagesAllList;

  const MoveableButton({
    Key? key,
    required this.text,
    required this.routing,
    this.carDamagesAllList,
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
        if (routing.length > 3) {
          if (routing.substring(routing.length - 3, routing.length) == 'mp4') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckCarDamageScreen(
                  filePath: routing,
                  carDamagesAllList: carDamagesAllList!,
                ),
              ),
            );
          }
        }
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
