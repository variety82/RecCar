import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({Key? key}) : super(key: key);

  @override
  State<AlarmSetting> createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  void turnSwitch() {}
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Header(
            title: '알림 설정',
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFD8D8D8),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "전체 알림",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF453F52),
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    // Card 위젯의 테두리를 없애주는 명령어  elevation: 0
                                    elevation: 0,
                                    child: Switch(
                                      value: _isChecked1,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked1 = value;
                                        });
                                      },
                                      activeColor: Color(0xFFE0426F),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "반납 당일 알림",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF453F52),
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    // Card 위젯의 테두리를 없애주는 명령어  elevation: 0
                                    elevation: 0,
                                    child: Switch(
                                      value: _isChecked2,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked2 = value;
                                        });
                                      },
                                      activeColor: Color(0xFFE0426F),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "ㅇㅇㅇㅇ 알림",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF453F52),
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    // Card 위젯의 테두리를 없애주는 명령어  elevation: 0
                                    elevation: 0,
                                    child: Switch(
                                      value: _isChecked3,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked3 = value;
                                        });
                                      },
                                      activeColor: Color(0xFFE0426F),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "ㅇㅇㅇㅇ 알림",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF453F52),
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    // Card 위젯의 테두리를 없애주는 명령어  elevation: 0
                                    elevation: 0,
                                    child: Switch(
                                      value: _isChecked4,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked4 = value;
                                        });
                                      },
                                      activeColor: Color(0xFFE0426F),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
