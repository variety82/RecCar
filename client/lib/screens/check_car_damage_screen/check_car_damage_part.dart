import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:client/screens/check_car_damage_screen/check_car_damage_detail_modal.dart';
import 'package:client/screens/after_check_damage_screen/after_check_damage_screen.dart';
import 'package:client/widgets/common/image_go_detail.dart';

class CheckCarDamagePart extends StatefulWidget {
  final String imageUrl;
  final VideoPlayerController videoPlayerController;
  final Map<String, dynamic> carDamage;
  final void Function(int) deleteDamageList;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;
  final void Function(BuildContext, Function, String, String, String, String,
      {dynamic data}) showConfirmationDialog;
  final String damageView;

  const CheckCarDamagePart({
    required this.imageUrl,
    required this.videoPlayerController,
    required this.carDamage,
    required this.changeDamageValue,
    required this.deleteDamageList,
    required this.showConfirmationDialog,
    required this.damageView,
  });

  @override
  State<CheckCarDamagePart> createState() => _CheckCarDamagePartState();
}

class _CheckCarDamagePartState extends State<CheckCarDamagePart> {
  List<String> damagedParts = []; // damagedParts 리스트 초기화
  String damageView = '미정';

  // timer 시, 분, 초 단위로 표시 전환해줌
  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF999999).withOpacity(0.5),
            spreadRadius: 0.3,
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(20),
        // color: Colors.black,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                maxHeight: 200,
              ),
              child: FadeInImage(
                placeholder:
                    AssetImage('lib/assets/images/loading_img/loading_gif.gif'),
                image: NetworkImage(widget.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 16,
                        ),
                        Text(
                          ' 타임 스탬프',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () async {
                        await widget.videoPlayerController.pause();
                        await widget.videoPlayerController.seekTo(
                          Duration(seconds: widget.carDamage["timeStamp"]),
                        );
                        await widget.videoPlayerController.play();
                      },
                      child: Text(
                        "${_durationToString(Duration(seconds: widget.carDamage["timeStamp"]))}",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 16,
                        ),
                        Text(
                          ' 손상 종류',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.damageView,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.car_crash,
                          size: 16,
                        ),
                        Text(
                          ' 차량 부위',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.carDamage["part"] != ""
                          ? widget.carDamage["part"]
                          : '미정',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: widget.carDamage['selected']
                ? Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      // height: MediaQuery.of(context).size.height * 6,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        child: CheckCarDamageDetailModal(
                                          carDamage: widget.carDamage,
                                          changeDamageValue:
                                              widget.changeDamageValue,
                                          imageUrl: widget.imageUrl,
                                          modalCase: '차량 손상 상세 확인',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "상세 보기",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      // height: MediaQuery.of(context).size.height * 6,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        child: CheckCarDamageDetailModal(
                                          carDamage: widget.carDamage,
                                          changeDamageValue:
                                              widget.changeDamageValue,
                                          imageUrl: widget.imageUrl,
                                          modalCase: '차량 손상 상세 수정',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "상세 수정",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            InkWell(
                              onTap: () {
                                widget.showConfirmationDialog(
                                    context,
                                    widget.deleteDamageList,
                                    '리스트에서 제외',
                                    '해당 손상 이미지를 리스트에서 제외합니다. 정말 괜찮으시겠습니까?',
                                    '예',
                                    '아니오',
                                    data: widget.carDamage['index']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "리스트 제외",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        useSafeArea: true,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SizedBox(
                            // height: MediaQuery.of(context).size.height * 6,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              child: CheckCarDamageDetailModal(
                                carDamage: widget.carDamage,
                                changeDamageValue: widget.changeDamageValue,
                                imageUrl: widget.imageUrl,
                                modalCase: '차량 손상 상세 등록',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Color(0xFFFBD5DC),
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "리스트 추가",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
