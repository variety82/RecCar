import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:client/widgets/common/image_go_detail.dart';
import 'package:client/widgets/check_car_damage/count_widget.dart';

class CheckCarDamageDetail extends StatefulWidget {
  final String imageUrl;
  final Map<String, dynamic> carDamage;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;

  const CheckCarDamageDetail({
    super.key,
    required this.imageUrl,
    required this.carDamage,
    required this.changeDamageValue,
  });

  @override
  State<CheckCarDamageDetail> createState() => _CheckCarDamageDetailState();
}

class _CheckCarDamageDetailState extends State<CheckCarDamageDetail> {
  String memoInput = '';
  String partInput = '';
  String imageFilePath = '';
  File? imageFile;
  late TextEditingController memoController;

  // 각 부위 별 파손 개수 변수로 지정
  int scratch_count = 0;
  int crushed_count = 0;
  int breakage_count = 0;
  int separated_count = 0;

  List<String> damage_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
  ];

  List<String> part_categories = [
    '앞범퍼/앞펜더/전조등',
    '뒷범퍼/뒷펜더/후미등',
    '옆면/사이드/스텝',
    '타이어/휠',
    '기타',
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      memoInput = widget.carDamage["memo"];
      print(memoInput);
      partInput = widget.carDamage["part"];
      scratch_count = widget.carDamage["scratch"];
      crushed_count = widget.carDamage["crushed"];
      breakage_count = widget.carDamage["breakage"];
      separated_count = widget.carDamage["separated"];
    });
    memoController = TextEditingController(text: memoInput);
    super.initState();
  }

  // count_widget에서 변경된 값을 damage_name에 따라 알맞는 변수에 반영함
  void checkChangeCount(String damage_name, int change_num) {
    if (damage_name == '스크래치') {
      setState(() {
        scratch_count = change_num;
      });
    } else if (damage_name == '찌그러짐') {
      setState(() {
        crushed_count = change_num;
      });
    } else if (damage_name == '파손') {
      setState(() {
        breakage_count = change_num;
      });
    } else if (damage_name == '이격') {
      setState(() {
        separated_count = change_num;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageFilePath = imageFile!.path;
      });
    }
  }

  Future<void> _takeImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageFilePath = imageFile!.path;
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('사진 선택'),
                onTap: () {
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
              // 다른 이미지 선택 옵션 추가 가능
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('사진 찍기'),
                onTap: () {
                  _takeImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _unUsedFocusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  '손상 사진',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                      maxHeight: 200,
                    ),
                    child: ImageGoDetail(
                      imagePath:
                          imageFilePath == '' ? widget.imageUrl : imageFilePath,
                      imageCase: imageFilePath == '' ? 'url' : 'file',
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       fixedSize: Size(120, 20),
                //       backgroundColor: Color(0xFFE0426F),
                //     ),
                //     onPressed: () {
                //       _showImagePicker();
                //     },
                //     child: Text(
                //       '이미지 변경',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),
                Text(
                  '손상 종류',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CountWidget(
                              damage_name: '스크래치',
                              count_num: scratch_count,
                              checkChangeCount: checkChangeCount,
                            ),
                            CountWidget(
                              damage_name: '찌그러짐',
                              count_num: crushed_count,
                              checkChangeCount: checkChangeCount,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CountWidget(
                              damage_name: '파손',
                              count_num: breakage_count,
                              checkChangeCount: checkChangeCount,
                            ),
                            CountWidget(
                              damage_name: '이격',
                              count_num: separated_count,
                              checkChangeCount: checkChangeCount,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        '차량 부위',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Center(
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 5,
                          children: part_categories.map(
                            (part_category) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (partInput == part_category) {
                                    setState(() {
                                      partInput = '';
                                    });
                                  } else {
                                    setState(() {
                                      partInput = part_category;
                                    });
                                  }
                                },
                                child: Chip(
                                    label: Text(
                                      part_category,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    backgroundColor:
                                        (partInput == part_category)
                                            ? Color(0xFFFBD5DC)
                                            : Colors.grey
                                    // deleteIconColor: Color(0xFFE0426F),
                                    ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        "메모",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 90,
                        child: TextField(
                          controller: memoController,
                          maxLines: 3,
                          onTapOutside: (PointerDownEvent event) {
                            FocusScope.of(context)
                                .requestFocus(_unUsedFocusNode);
                          },
                          onChanged: (text) {
                            setState(
                              () {
                                memoInput = text;
                              },
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                            labelText: '',
                            hintText: '메모를 입력해주세요.',
                          ),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 13,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                            )
                          ],
                        ),
                        child: Text(
                          "취소",
                          style: TextStyle(
                            color: Color(0xFF453F52),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        widget.changeDamageValue(
                          widget.carDamage["index"],
                          partInput,
                          scratch_count,
                          crushed_count,
                          breakage_count,
                          separated_count,
                          memoInput,
                        ),
                        Navigator.of(context).pop(),
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 13,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFE0426F)),
                        child: Text(
                          "등록",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
