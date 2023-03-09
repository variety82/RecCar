import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/rent_log_card.dart';
import './rent_log_detail.dart';

class RentLog extends StatefulWidget {
  const RentLog({Key? key}) : super(key: key);

  @override
  State<RentLog> createState() => _RentLogState();
}

class _RentLogState extends State<RentLog> {
  @override
  Widget build(BuildContext context) {
    // late var rentCnt;

    void getRentLog() {
      // 여기에 api로 get하고
      // setState로 rentCnt를 변경해주자!
      // 날짜, 회사, 파손 개수 데이터도 여기서 setState로 받자!
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 80,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 렌트 내역 개수 출력
                Text(
                  // 추후 RentCnt로 출력
                  "총 6건의 렌트 내역이 있습니다",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // 간격
          SizedBox(
            height: 20,
          ),
          Expanded(
            // 렌트 내역은 스크롤이 가능하게
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 추후 rentCnt만큼 돌림
                  // 렌트 내역을 리스트로 출력
                  for (int i = 0; i < 6; i++)
                    // RentLogCard라는 widget에 데이터를 넘겨줌
                    RentLogCard(
                      startDate: "2021.11.26",
                      endDate: "2021.11.27",
                      company: "그린카",
                      damage: 3,
                      id: i,
                    ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
