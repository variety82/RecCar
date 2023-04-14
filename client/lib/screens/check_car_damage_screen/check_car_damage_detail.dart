import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:client/widgets/common/image_go_detail.dart';
import 'package:client/widgets/check_car_damage/count_widget.dart';

class CheckCarDamageDetail extends StatefulWidget {
  final String imageUrl;
  final String modalCase;
  final Map<String, dynamic> carDamage;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;

  const CheckCarDamageDetail({
    super.key,
    required this.imageUrl,
    required this.modalCase,
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
  String modalCase = '';
  File? imageFile;
  late TextEditingController memoController;

  // 각 유형 별 파손 개수 변수로 지정
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
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      memoInput = widget.carDamage["memo"];
      partInput = widget.carDamage["part"];
      scratch_count = widget.carDamage["Scratch"];
      crushed_count = widget.carDamage["Crushed"];
      breakage_count = widget.carDamage["Breakage"];
      separated_count = widget.carDamage["Separated"];
      modalCase = widget.modalCase;
    });
    memoController = TextEditingController(text: memoInput);
    super.initState();
  }

  // count_widget에서 변경된 값을 damage_name에 따라 알맞는 변수에 반영함
  void checkChangeCount(String damageName, int changeNum) {
    if (damageName == '스크래치') {
      setState(() {
        scratch_count = changeNum;
      });
    } else if (damageName == '찌그러짐') {
      setState(() {
        crushed_count = changeNum;
      });
    } else if (damageName == '파손') {
      setState(() {
        breakage_count = changeNum;
      });
    } else if (damageName == '이격') {
      setState(() {
        separated_count = changeNum;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageFilePath = imageFile!.path;
      });
    }
  }

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
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
                leading: const Icon(Icons.photo_library),
                title: const Text('사진 선택'),
                onTap: () {
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
              // 다른 이미지 선택 옵션 추가 가능
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('사진 찍기'),
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
    FocusNode unUsedFocusNode = FocusNode();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: RawScrollbar(
    thumbVisibility: true,
    radius: const Radius.circular(10),
    thumbColor: Theme.of(context).primaryColor,
    thickness: 5,
    child: Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 8,
    ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      '손상 사진',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(
                        '사진을 클릭하면 확대됩니다',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                          maxHeight: 300,
                        ),
                        child: ImageGoDetail(
                          imagePath: imageFilePath == ''
                              ? widget.imageUrl
                              : imageFilePath,
                          imageCase: imageFilePath == '' ? 'url' : 'file',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 16,
                                color: Color.fromRGBO(240, 15, 135, 0.75),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '스크래치',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(240, 15, 135, 0.75),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 16,
                                color: Color.fromRGBO(64, 64, 64, 0.75),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '찌그러짐',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(64, 64, 64, 0.75),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 16,
                                color: Color.fromRGBO(75, 150, 200, 0.75),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '파손',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(75, 150, 200, 0.75),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '손상 종류',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    widget.modalCase != "차량 손상 상세 확인"
                        ? (scratch_count +
                                    breakage_count +
                                    crushed_count +
                                    separated_count) ==
                                0
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '최소 하나 이상의 손상 종류를 설정해주세요',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            : const SizedBox(
                                height: 25,
                                width: 20,
                              )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.modalCase == "차량 손상 상세 확인"
                          ? Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 5,
                              children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Chip(
                                            label: Text(
                                              '스크래치',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: scratch_count > 0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: scratch_count > 0
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : Theme.of(context).shadowColor,
                                            // deleteIconColor: Color(0xFFE0426F),
                                          ),
                                          Text(
                                            scratch_count.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: scratch_count > 0
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Chip(
                                            label: Text(
                                              '찌그러짐',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: crushed_count > 0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: crushed_count > 0
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : Theme.of(context).shadowColor,
                                            // deleteIconColor: Color(0xFFE0426F),
                                          ),
                                          Text(
                                            crushed_count.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: crushed_count > 0
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Chip(
                                            label: Text(
                                              '파손',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: breakage_count > 0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: breakage_count > 0
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : Theme.of(context).shadowColor,
                                            // deleteIconColor: Color(0xFFE0426F),
                                          ),
                                          Text(
                                            breakage_count.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: breakage_count > 0
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Chip(
                                            label: Text(
                                              '이격',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: separated_count > 0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: separated_count > 0
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : Theme.of(context).shadowColor,
                                            // deleteIconColor: Color(0xFFE0426F),
                                          ),
                                          Text(
                                            separated_count.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: separated_count > 0
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                          const Text(
                            '차량 부위',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          widget.modalCase != "차량 손상 상세 확인"
                              ? partInput == ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        '차량 부위를 선택해주세요',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 25,
                                      width: 20,
                                    )
                              : Container(),
                          Center(
                            child: widget.modalCase == "차량 손상 상세 확인"
                                ? Chip(
                                    label: Text(
                                      partInput,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    // deleteIconColor: Color(0xFFE0426F),
                                  )
                                : Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 5,
                                    children: part_categories.map(
                                      (partCategory) {
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            if (partInput == partCategory) {
                                              setState(() {
                                                partInput = '';
                                              });
                                            } else {
                                              setState(() {
                                                partInput = partCategory;
                                              });
                                            }
                                          },
                                          child: Chip(
                                            label: Text(
                                              partCategory,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: (partInput == partCategory)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            backgroundColor: (partInput ==
                                                    partCategory)
                                                ? const Color(0xFFFBD5DC)
                                                : Theme.of(context).shadowColor,
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
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "메모",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          widget.modalCase == "차량 손상 상세 확인"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    memoInput == "" ? "없음" : memoInput,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    height: 90,
                                    child: TextField(
                                      controller: memoController,
                                      maxLines: 3,
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusScope.of(context)
                                            .requestFocus(unUsedFocusNode);
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
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
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
                            padding: const EdgeInsets.symmetric(
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
                              widget.modalCase == "차량 손상 상세 확인" ? "닫기" : "취소",
                              style: const TextStyle(
                                color: Color(0xFF453F52),
                              ),
                            ),
                          ),
                        ),
                        widget.modalCase == "차량 손상 상세 등록" ||
                                widget.modalCase == "차량 손상 상세 수정"
                            ? TextButton(
                                onPressed: () => {
                                  if ((scratch_count +
                                              crushed_count +
                                              breakage_count +
                                              separated_count) ==
                                          0 ||
                                      partInput == '')
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                                        SnackBar(
                                          content: const Center(
                                            child: Text(
                                              "손상 유형 및 부위를 모두 설정해주세요.",
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          duration:
                                              const Duration(milliseconds: 1000),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    }
                                  else
                                    {
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
                                    }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 13,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ((scratch_count +
                                                      crushed_count +
                                                      breakage_count +
                                                      separated_count) ==
                                                  0 ||
                                              partInput == '')
                                          ? Theme.of(context).shadowColor
                                          : Theme.of(context).primaryColor),
                                  child: Text(
                                    widget.modalCase == "차량 손상 상세 수정"
                                        ? "수정"
                                        : "추가",
                                    style: TextStyle(
                                      color: ((scratch_count +
                                                      crushed_count +
                                                      breakage_count +
                                                      separated_count) ==
                                                  0 ||
                                              partInput == '')
                                          ? Theme.of(context).disabledColor
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),)
    );
  }
}
