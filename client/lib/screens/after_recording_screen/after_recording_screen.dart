import 'package:flutter/material.dart';

import 'package:client/widgets/common/moveable_button.dart';
import 'package:client/services/analysis_car_damage_api.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_screen.dart';
import 'package:client/screens/after_recording_screen/damage_count_info_block.dart';

// 만약 애니메이션 효과 추가 시, 수정 필요
class AfterRecordingScreen extends StatefulWidget {
  final String filePath;

  const AfterRecordingScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<AfterRecordingScreen> createState() => _AfterRecordingScreenState();
}

class _AfterRecordingScreenState extends State<AfterRecordingScreen> {
  bool loading_api = true;

  List<Map<String, dynamic>> carDamagesAllList = [];

  @override
  void initState() {
    analysisCarDamageApi(
      success: (dynamic response) {
        setState(() {
          carDamagesAllList = response;
          loading_api = false;
        });
      },
      fail: (error) {
        print('차량 손상 분석 오류: $error');
        setState(
          () {
            loading_api = false;
          },
        );
      },
      filePath: widget.filePath,
      user_id: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor는 흰색으로 설정
        backgroundColor: Colors.white,
        // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: loading_api
                  ? Center(
                      // 상하 간격
                      child: Wrap(
                        // 세로로 나열
                        direction: Axis.vertical,
                        // 나열 방향
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // 정렬 방식
                        spacing: 24,
                        // 좌우 간격
                        runSpacing: 10,
                        children: [
                          Column(
                            children: [
                              Text(
                                '녹화가',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              Text(
                                '완료되었습니다.',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF453F52),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '영상을 분석 중입니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF3F3F),
                                ),
                                softWrap: true,
                              ),
                              Text(
                                '도중에 앱을 중지하지 마세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF3F3F),
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 400,
                            ),
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  'lib/assets/images/loading_img/loading_gif.gif'),
                              image: NetworkImage(
                                  'https://cdn.dribbble.com/users/11867/screenshots/2989212/_british_car_gif2.gif'),
                            ),
                          ),
                          // CircularProgressIndicator(
                          //   color: Color(0xFFE0426F),
                          //   // strokeWidth: 8,
                          // ),
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
                        spacing: 24,
                        // 좌우 간격
                        runSpacing: 10,
                        children: [
                          Column(
                            children: [
                              Text(
                                '분석이',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF453F52),
                                ),
                              ),
                              Text(
                                '완료되었습니다!',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF453F52),
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '총 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: '15',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF3F3F),
                                  ),
                                ),
                                TextSpan(
                                  text: '건의 손상이 발견되었습니다.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  '* 현재 이격은 기록만 가능합니다 *',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFF3F3F),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DamageCountInfoBlock(
                                    damageName: '스크래치',
                                    damageCnt: 8,
                                  ),
                                  DamageCountInfoBlock(
                                    damageName: '찌그러짐',
                                    damageCnt: 8,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DamageCountInfoBlock(
                                    damageName: '파손',
                                    damageCnt: 8,
                                  ),
                                  DamageCountInfoBlock(
                                    damageName: '이격',
                                    damageCnt: 8,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 50),
                              backgroundColor: Color(0xFFE0426F),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckCarDamageScreen(
                                    filePath: widget.filePath,
                                    carDamagesAllList: carDamagesAllList!,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "확인하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
