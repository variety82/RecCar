import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/screens/after_recording_screen/damage_count_info_block.dart';
import 'package:client/services/check_car_api.dart';

// 만약 애니메이션 효과 추가 시, 수정 필요
class AfterCheckDamageScreen extends StatefulWidget {
  final String filePath;
  final List<Map<String, dynamic>> carDamagesAllList;

  const AfterCheckDamageScreen({
    Key? key,
    required this.filePath,
    required this.carDamagesAllList,
  }) : super(key: key);

  @override
  State<AfterCheckDamageScreen> createState() => _AfterCheckDamageScreen();
}

class _AfterCheckDamageScreen extends State<AfterCheckDamageScreen> {
  bool load_data = false;
  bool loading_api = false;
  List<Map<String, dynamic>> damageInfoList = [];

  static const storage = FlutterSecureStorage();
  int? currentCarId;
  int? currentCarVideo;
  late DateTime nowDateTime;
  bool? formerState;

  // 각 유형 별 파손 개수 변수로 지정
  num scratch_count = 0;
  num crushed_count = 0;
  num breakage_count = 0;
  num separated_count = 0;

  // 각 부위 별 파손 개수 변수로 지정
  int front_count = 0;
  int back_count = 0;
  int side_count = 0;
  int wheel_count = 0;

  Future<void> setCurrentCarId() async {
    final carId = await storage.read(key: 'carId');
    setState(() {
      currentCarId = int.parse(carId!);
    });
  }

  Future<void> setCurrentCarVideo() async {
    final carVideoState = await storage.read(key: 'carVideoState');
    setState(() {
      if (carVideoState == '0') {
        setState(() {
          currentCarVideo = 0;
          formerState = true;
        });
      } else if (carVideoState == '1') {
        setState(() {
          currentCarVideo = 1;
          formerState = false;
        });
      } else {
        setState(() {
          currentCarVideo = 2;
          formerState = false;
        });
      }
    });
  }

  String checkDamagePart(Map<String, dynamic> damage) {
    if (damage["part"] == "앞범퍼/앞펜더/전조등") {
      setState(() {
        front_count += 1;
      });
      return 'front';
    } else if (damage["part"] == "뒷범퍼/뒷펜더/후미등") {
      setState(() {
        back_count += 1;
      });
      return 'back';
    } else if (damage["part"] == "옆면/사이드/스텝") {
      setState(() {
        side_count += 1;
      });
      return 'side';
    } else if (damage["part"] == "타이어/휠") {
      setState(() {
        wheel_count += 1;
      });
      return 'wheel';
    }
    return 'none';
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 10));
    dataChange();
  }

  void dataChange() {
    widget.carDamagesAllList
        .where((damage) => damage['selected'] == true)
        .forEach((damage) {
      Map<String, dynamic> carDamageInfo = {
        // "carId": int.parse(currentCarId!),
        "carId": currentCarId ?? 0,
        "former": formerState ?? false,
        "pictureUrl": damage["Damage_Image_URL"],
        "part": checkDamagePart(damage),
        "memo": damage["memo"],
        "damageDate": nowDateTime.toIso8601String(),
        "scratch": damage["Scratch"],
        "breakage": damage["Breakage"],
        "crushed": damage["Crushed"],
        "separated": damage["Separated"],
      };

      setState(() {
        damageInfoList.add(carDamageInfo);
        scratch_count += damage["Scratch"];
        breakage_count += damage["Breakage"];
        crushed_count += damage["Crushed"];
        separated_count += damage["Separated"];
      });
    });
    setState(() {
      load_data = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setCurrentCarId();
    setCurrentCarVideo();
    nowDateTime = DateTime.now();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // backgroundColor는 흰색으로 설정
      backgroundColor: Colors.white,
      // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
      body: load_data
          ? Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: loading_api
                      ? Center(
                          // 상하 간격
                          child: Wrap(
                            // 세로로 나열
                            direction: Axis.vertical,
                            // 나열 방향
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // 정렬 방식
                            spacing: 20,
                            // 좌우 간격
                            runSpacing: 10,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    currentCarVideo! + 1 == 1
                                        ? '대여 시 손상의'
                                        : '반납 시 손상의',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF453F52),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    '등록이',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF453F52),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    '완료되었습니다!',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF453F52),
                                    ),
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '총 ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      // text: damageInfoList.length.toString(),
                                      text: (scratch_count +
                                              separated_count +
                                              crushed_count +
                                              breakage_count)
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '건의 손상이 등록되었습니다',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  maxHeight: 120,
                                ),
                                child: Image.asset(
                                  'lib/assets/images/loading_img/loading_done_gif.gif',
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        fixedSize: const Size(80, 80),
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/detail',
                                          arguments: {
                                            'currentCarVideo':
                                                (currentCarVideo! + 1)
                                                    .toString(),
                                          },
                                          ModalRoute.withName('/home'),
                                        );
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.car_crash),
                                          Text(
                                            "차량 상세",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        fixedSize: const Size(80, 80),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/home',
                                          ModalRoute.withName('/home'),
                                        );
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.home),
                                          Text(
                                            "메인 화면",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Center(
                          // 상하 간격
                          child: Wrap(
                            // 세로로 나열
                            direction: Axis.vertical,
                            // 나열 방향
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // 정렬 방식
                            spacing: 10,
                            // 좌우 간격
                            runSpacing: 10,
                            children: [
                              Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '총 ',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF453F52),
                                          ),
                                        ),
                                        TextSpan(
                                          text: (scratch_count +
                                                  separated_count +
                                                  crushed_count +
                                                  breakage_count)
                                              .toInt()
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '건의 손상을',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF453F52),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    '등록할 예정입니다',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF453F52),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DamageCountInfoBlock(
                                          damageName: "스크래치",
                                          damageCnt: scratch_count.toInt(),
                                        ),
                                        DamageCountInfoBlock(
                                          damageName: "찌그러짐",
                                          damageCnt: crushed_count.toInt(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DamageCountInfoBlock(
                                          damageName: "파손",
                                          damageCnt: breakage_count.toInt(),
                                        ),
                                        DamageCountInfoBlock(
                                          damageName: "이격",
                                          damageCnt: separated_count.toInt(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                '정말 등록하시겠습니까?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                                softWrap: true,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        fixedSize: const Size(80, 80),
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.keyboard_backspace),
                                          Text(
                                            "돌아가기",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        fixedSize: const Size(80, 80),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        if (damageInfoList.isNotEmpty) {
                                          postCarDamageInfo(
                                            success: (dynamic response) async {
                                              await storage.write(
                                                  key: "carVideoState",
                                                  value: currentCarVideo == 0
                                                      ? '1'
                                                      : '2');
                                              setState(() {
                                                load_data = true;
                                                loading_api = true;
                                              });
                                            },
                                            fail: (error) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/error',
                                                arguments: {
                                                  'errorText': error,
                                                },
                                                ModalRoute.withName('/home'),
                                              );
                                              print('차량 손상 분석 오류: $error');
                                              // setState(
                                              //   () {
                                              //     loading_api = true;
                                              //   },
                                              // );
                                            },
                                            bodyList: damageInfoList,
                                          );
                                        } else {
                                          await storage.write(
                                              key: "carVideoState",
                                              value: currentCarVideo == 0
                                                  ? '1'
                                                  : '2');
                                          setState(() {
                                            load_data = true;
                                            loading_api = true;
                                          });
                                        }
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save_as),
                                          Text(
                                            "등록하기",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    ));
  }
}
