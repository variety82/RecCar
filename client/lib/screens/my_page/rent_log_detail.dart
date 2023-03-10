import 'package:client/screens/my_page/rent_log_detail_after.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import './rent_log_detail_before.dart';

class RentLogDetail extends StatelessWidget {
  final int id;

  const RentLogDetail({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        // 탭의 수 설정
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            // TabBar 구현. 각 컨텐트를 호출할 탭들을 등록
            bottom: TabBar(
              labelColor: Color(0xFFE0426F),
              unselectedLabelColor: Color(0xFF989696),
              indicatorColor: Color(0xFFE0426F),
              indicatorWeight: 3,
              tabs: [
                Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      "대여 이전",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      "대여 이후",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    )),
              ],
            ),
          ),
          // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
          body: TabBarView(
            children: [
              BeforeRent(
                startDate: "2021.10.20 11:00",
                endDate: "2021.10.23 17:00",
                rentCompany: "쏘카",
                manufacturingCompany: "현대",
                carName: "소나타",
                carNumber: "38모 6715",
                id: id,
              ),
              AfterRent(
                startDate: "2021.10.20 11:00",
                endDate: "2021.10.23 17:00",
                rentCompany: "쏘카",
                manufacturingCompany: "현대",
                carName: "소나타",
                carNumber: "38모 6715",
                id: id,
              ),
            ],
          ),
          bottomNavigationBar: Footer(),
        ),
      ),
    );
  }
}
