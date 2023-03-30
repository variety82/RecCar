import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_part.dart';

class CheckCarDamageContainer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final List<Map<String, dynamic>> carDamageList;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;

  const CheckCarDamageContainer({
    required this.videoPlayerController,
    required this.carDamageList,
    required this.changeDamageValue,
  });
  // Widget buildItem(Map<String, dynamic> carDamage) {
  //   return ListTile(
  //     "Damage_Image_URL": carDamage,
  //     "part": "",
  //     "damage": {},
  //     "memo": "",
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbVisibility: true,
      radius: Radius.circular(10),
      thumbColor: Color(0xFF453F52).withOpacity(0.5),
      thickness: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: ListView(children: [
          for (int i = 0; i < carDamageList.length; i++)
            Padding(
              padding: const EdgeInsets.all(12),
              child: CheckCarDamagePart(
                imageUrl: carDamageList[i]["Damage_Image_URL"],
                videoPlayerController: videoPlayerController,
                carDamage: carDamageList[i],
                changeDamageValue: changeDamageValue,
              ),
            ),
          // Text(carDamageList[i]["Damage_Image_URL"]),
        ]),
      ),
    );
  }
}

//carDamageList
//               .map((carDamage) {
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: CheckCarDamagePart(
//                 imageUrl:
//                 'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_user_50_2023-03-23_14-24-26_3.jpg',
//                 videoPlayerController: videoPlayerController,
//               ),
//             ),
//           },
//
//               )
//               .toList(),
