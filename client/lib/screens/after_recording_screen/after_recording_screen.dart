import 'package:flutter/material.dart';

// 촬영 전 페이지 statelessWidget으로 구현
// 만약 애니메이션 효과 추가 시, 수정 필요
class AfterRecordingScreen extends StatelessWidget {
  const AfterRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor는 흰색으로 설정
      backgroundColor: Colors.white,
      // Column 정렬 이용해 화면 정가운데에 이하 요소들을 정렬
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Center(
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
                  Text(
                    '녹화가 완료되었습니다.',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF453F52),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '영상을 분석 중입니다...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF3F3F),
                        ),
                        softWrap: true,
                      ),
                      Text(
                        '도중에 앱을 중지하지 마세요.',
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
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      color: Color(0xFFE0426F),
                      strokeWidth: 12,
                    ),
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
