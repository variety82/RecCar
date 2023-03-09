import 'package:flutter/material.dart';

// import widgets
import 'package:client/screens/before_recording_screen/before_recording_button_widget.dart';

// 촬영 전 페이지 statelessWidget으로 구현
// 만약 애니메이션 효과 추가 시, 수정 필요
class BeforeRecordingScreen extends StatelessWidget {
  const BeforeRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor는 흰색으로 설정
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFFF3F3F),
      ),
      // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // padding 추가해줌
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                // 각 요소를 묶어 간격 조절하기를 원하므로, Wrap를 이용
                // 일단 모든 요소를 Wrap을 통해 하나로 묶은 후, 원하는 파트 별로 다시 Wrap으로 묶었음(button 이외)
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // 상하 간격
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Wrap(
                        // 세로로 나열
                        direction: Axis.vertical,
                        // 나열 방향
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // 정렬 방식
                        spacing: 10,
                        // 좌우 간격
                        children: [
                          Text(
                            '지금부터',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF453F52),
                            ),
                          ),
                          Text(
                            '녹화가 시작됩니다.',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF453F52),
                            ),
                          ),
                          Text(
                            '주의해주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF3F3F),
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Text(
                        '주변이 어두울 때에는 라이트를 켠 상태에서 촬영해주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Text(
                        '너무 빠르게 화면을 이동하지 말아주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: BeforeRecordingButton(
                        text: '녹화 시작',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
