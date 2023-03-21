import 'package:flutter/material.dart';

import 'package:client/widgets/common/moveable_button.dart';

// 만약 애니메이션 효과 추가 시, 수정 필요
class AfterRecordingScreen extends StatefulWidget {
  final String filePath;

  const AfterRecordingScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<AfterRecordingScreen> createState() => _AfterRecordingScreenState();
}

class _AfterRecordingScreenState extends State<AfterRecordingScreen> {
  bool _loarding = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor는 흰색으로 설정
      backgroundColor: Colors.white,
      // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: _loarding
                ? const Center(
                    // 상하 간격
                    child: Wrap(
                      // 세로로 나열
                      direction: Axis.vertical,
                      // 나열 방향
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // 정렬 방식
                      spacing: 40,
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
                                color: Color(0xFF453F52),
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
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            color: Color(0xFFE0426F),
                            strokeWidth: 8,
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
                        const Column(
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
                        // Text(
                        //   '총 15건의 손상이 감지되었습니다.',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     color: Color(0xFFFF3F3F),
                        //   ),
                        //   softWrap: true,
                        // ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBD5DC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '스크래치',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '------',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '8건',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFF3F3F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBD5DC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '스크래치',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                          thickness: 2,
                                          indent: 16,
                                          endIndent: 16,
                                          height: 24,
                                        ),
                                        // Text(
                                        //   '------',
                                        //   style: TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 16,
                                        //   ),
                                        // ),
                                        Text(
                                          '8건',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFF3F3F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBD5DC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '스크래치',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '----------',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '8건',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFF3F3F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBD5DC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '스크래치',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '------',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '8건',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFF3F3F),
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
                        MoveableButton(
                          text: '확인하기',
                          routing: widget.filePath,
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
