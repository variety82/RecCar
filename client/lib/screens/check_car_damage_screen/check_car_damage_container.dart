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
  final void Function(int) deleteDamageList;
  final void Function(BuildContext, Function, String, String, String, String, {dynamic data}) showConfirmationDialog;
  final bool isSelectedView;

  CheckCarDamageContainer({
    required this.videoPlayerController,
    required this.carDamageList,
    required this.selectedIndexList,
    required this.changeDamageValue,
    required this.isSelectedView,
    required this.deleteDamageList,
    required this.showConfirmationDialog,
  });

  @override
  State<CheckCarDamageContainer> createState() =>
      _CheckCarDamageContainerState();
}

class _CheckCarDamageContainerState extends State<CheckCarDamageContainer> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _selectedScrollController = ScrollController();

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
                  Column(children: widget.carDamageList.where((damage) => damage['selected'] == true)
                      .map((damage) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: CheckCarDamagePart(
                      imageUrl: damage['Damage_Image_URL'],
                      videoPlayerController: widget.videoPlayerController,
                      carDamage: damage,
                      changeDamageValue: widget.changeDamageValue,
                      deleteDamageList: widget.deleteDamageList,
                      showConfirmationDialog: widget.showConfirmationDialog,
                      damageView: damage["damageView"] ?? "미정",
                    ),
                  ))
                      .toList(),)
                ],
              )
            : ListView(
                controller: widget.isSelectedView
                    ? _selectedScrollController
                    : _scrollController,
                children: widget.carDamageList
            .where((damage) => damage['selected'] == false)
          .map((damage) => Padding(
        padding: const EdgeInsets.all(12),
        child: CheckCarDamagePart(
          imageUrl: damage['Damage_Image_URL'],
          videoPlayerController: widget.videoPlayerController,
          carDamage: damage,
          changeDamageValue: widget.changeDamageValue,
            deleteDamageList: widget.deleteDamageList,
            showConfirmationDialog: widget.showConfirmationDialog,
          damageView: damage["damageView"] ?? "미정",
        ),
      ))
          .toList(),
              ),
      ),
    );
  }
}
