import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_part.dart';

class CheckCarDamageContainer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  const CheckCarDamageContainer({required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5, // Container 높이 설정
        child: RawScrollbar(
          thumbVisibility: true,
          radius: Radius.circular(10),
          thumbColor: Color(0xFF453F52).withOpacity(0.5),
          thickness: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CheckCarDamagePart(
                      imageUrl:
                          'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_user_50_2023-03-23_14-24-26_3.jpg',
                      videoPlayerController: videoPlayerController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CheckCarDamagePart(
                      imageUrl:
                          'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_user_50_2023-03-23_14-24-26_3.jpg',
                      videoPlayerController: videoPlayerController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
