import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_part.dart';

class CheckCarDamageContainer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final List<Map<String, dynamic>> carDamageList;
  final List<int> selectedIndexList;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;
  final bool isSelectedView;
  // final ValueNotifier<List<Map<String, dynamic>>> damageInfoNotifier;

  CheckCarDamageContainer({
    required this.videoPlayerController,
    required this.carDamageList,
    required this.selectedIndexList,
    required this.changeDamageValue,
    required this.isSelectedView,
    // required this.damageInfoNotifier,
  });

  @override
  State<CheckCarDamageContainer> createState() =>
      _CheckCarDamageContainerState();
}

class _CheckCarDamageContainerState extends State<CheckCarDamageContainer> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _selectedScrollController = ScrollController();

  @override
  // Widget buildItem(Map<String, dynamic> carDamage) {
  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller:
          widget.isSelectedView ? _selectedScrollController : _scrollController,
      thumbVisibility: true,
      radius: Radius.circular(10),
      thumbColor: Color(0xFF453F52).withOpacity(0.5),
      thickness: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: widget.isSelectedView
            ? ListView(
                children: [
                  for (int i = 0; i < widget.selectedIndexList.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CheckCarDamagePart(
                        imageUrl:
                            widget.carDamageList[widget.selectedIndexList[i]]
                                ["Damage_Image_URL"],
                        videoPlayerController: widget.videoPlayerController,
                        carDamage:
                            widget.carDamageList[widget.selectedIndexList[i]],
                        changeDamageValue: widget.changeDamageValue,
                      ),
                    ),
                  // Text(carDamageList[i]["Damage_Image_URL"]),
                ],
              )
            : ListView(
                controller: widget.isSelectedView
                    ? _selectedScrollController
                    : _scrollController,
                children: [
                  for (int i = 0; i < widget.carDamageList.length; i++)
                    if (!widget.selectedIndexList.contains(i))
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CheckCarDamagePart(
                          imageUrl: widget.carDamageList[i]["Damage_Image_URL"],
                          videoPlayerController: widget.videoPlayerController,
                          carDamage: widget.carDamageList[i],
                          changeDamageValue: widget.changeDamageValue,
                        ),
                      ),
                  // Text(carDamageList[i]["Damage_Image_URL"]),
                ],
              ),
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
