import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  void home() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.home_outlined,
            color: Color(0xFFABABAB),
            size: 30,
          ),
          Icon(
            Icons.local_gas_station_outlined,
            color: Color(0xFFABABAB),
            size: 30,
          ),
          Transform.translate(
            offset: Offset(0, -10),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 30,
                color: Colors.white.withOpacity(0.8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0XFFE0426F),
              ),
            ),
          ),
          Icon(
            Icons.event_note_outlined,
            color: Color(0XFFABABAB),
            size: 30,
          ),
          Icon(
            Icons.person_outline,
            color: Color(0XFFABABAB),
            size: 30,
          ),
        ],
      ),
    );
  }
}
