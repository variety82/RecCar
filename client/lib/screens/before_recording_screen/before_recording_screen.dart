import 'package:flutter/material.dart';
import 'package:client/widgets/MainButton.dart';

class BeforeRecordingScreen extends StatelessWidget {
  const BeforeRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 60,
            ),
            child: Wrap(
              direction: Axis.horizontal,
              // 나열 방향
              alignment: WrapAlignment.center,
              // 정렬 방식
              spacing: 10,
              // 좌우 간격
              runSpacing: 40,
              // 상하 간격
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  // 나열 방향
                  alignment: WrapAlignment.center,
                  // 정렬 방식
                  spacing: 10,
                  // 좌우 간격
                  runSpacing: 10,
                  // 상하 간격
                  children: [
                    Text(
                      '지금부터',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF453F52),
                      ),
                    ),
                    Text(
                      '녹화가 시작됩니다.',
                      textAlign: TextAlign.center,
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
                          color: Color(0xFFFF3F3F)),
                    ),
                  ],
                ),
                Wrap(
                  direction: Axis.horizontal,
                  // 나열 방향
                  alignment: WrapAlignment.center,
                  // 정렬 방식
                  spacing: 10,
                  // 좌우 간격
                  runSpacing: 16,
                  // 상하 간격
                  children: [
                    Text(
                      '주변이 어두울 때에는 라이트를 킨 상태에서 촬영해주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '너무 빠르게 화면을 이동하지 말아주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                MainButton(text: '녹화 시작'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
