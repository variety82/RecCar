import 'package:flutter/material.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_part.dart';

class CheckCarDamageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45, // Container 높이 설정
        child: RawScrollbar(
          thumbVisibility: true,
          radius: Radius.circular(10),
          thumbColor: Color(0xFF453F52).withOpacity(0.5),
          thickness: 5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CheckCarDamagePart(
                    imageUrl:
                        'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_user_50_2023-03-23_14-24-26_3.jpg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CheckCarDamagePart(
                    imageUrl:
                        'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_user_50_2023-03-23_14-24-26_3.jpg',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
