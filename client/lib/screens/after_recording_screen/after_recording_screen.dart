import 'package:flutter/material.dart';

import 'package:client/services/analysis_car_damage_api.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 만약 애니메이션 효과 추가 시, 수정 필요
class AfterRecordingScreen extends StatefulWidget {
  final String filePath;

  const AfterRecordingScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<AfterRecordingScreen> createState() => _AfterRecordingScreenState();
}

class _AfterRecordingScreenState extends State<AfterRecordingScreen> {
  bool loading_api = false;

  static const storage = FlutterSecureStorage();
  String? userNickName;

  List<Map<String, dynamic>> carDamagesAllList = [];
  List<int> selectedIndexList = [];

  Future<void> setUserName() async {
    final userName = await storage.read(key: 'nickName');
    setState(() {
      userNickName = userName;
    });
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    analysisCarDamageApi(
      success: (dynamic response) {
        setState(() {
          carDamagesAllList = response;
          loading_api = true;
        });
      },
      fail: (error) {
        setState(
          () {
            loading_api = true;
          },
        );
      },
      filePath: widget.filePath,
      user_id: userNickName ?? 'default',
    );
  }

  @override
  void initState() {
    super.initState();
    setUserName();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor는 흰색으로 설정
        // backgroundColor: Colors.white,
        // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
        body: Center(
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
                        spacing: 24,
                        // 좌우 간격
                        runSpacing: 10,
                        children: [
                          const Column(
                            children: [
                              Text(
                                '분석이',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF453F52),
                                ),
                              ),
                              Text(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 140,
                                maxHeight: 140,
                              ),
                              child: Image.asset(
                                'lib/assets/images/loading_img/complete_gif.gif',
                              ),
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Theme.of(context).primaryColor),
                              ),
                              fixedSize: const Size(180, 50),
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).primaryColor,
                              shadowColor: Theme.of(context).shadowColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckCarDamageScreen(
                                    filePath: widget.filePath,
                                    carDamagesAllList: carDamagesAllList,
                                    selectedIndexList: selectedIndexList,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "확인하기",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                        spacing: 32,
                        // 좌우 간격
                        runSpacing: 10,
                        children: [
                          Column(
                            children: [
                              Text(
                                '영상 업로드가',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              Text(
                                '완료되었습니다.',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).secondaryHeaderColor,
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
                                  color: Theme.of(context).primaryColor,
                                ),
                                softWrap: true,
                              ),
                              Text(
                                '도중에 앱을 중지하지 마세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 180,
                              maxHeight: 180,
                            ),
                            child: Image.asset(
                              'lib/assets/images/loading_img/car_spinning.gif',
                            ),
                          ),
                          // CircularProgressIndicator(
                          //   color: Theme.of(context).primaryColor,
                          //   // strokeWidth: 8,
                          // ),
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
