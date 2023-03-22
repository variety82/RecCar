import 'package:client/screens/my_page/rent_log_detail_after.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/rent_log_line.dart';
import './rent_log_detail_before.dart';

class RentLogDetail extends StatelessWidget {
  final int id;
  final String startDate;
  final String endDate;
  final String rentCompany;
  final String manufacturingCompany;
  final String carName;
  final String carNumber;

  const RentLogDetail({
    super.key,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.rentCompany,
    required this.manufacturingCompany,
    required this.carName,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 10,
                backgroundColor: Colors.white,
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
              body: TabBarView(
                children: [
                  BeforeRent(id: id),
                  AfterRent(id: id),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "이용 정보",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RentLogLine(
                    infoTitle: "대여 일자",
                    info: "${startDate}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "반납 일자",
                    info: "${endDate}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "대여 업체",
                    info: "${rentCompany}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "제조사",
                    info: "${manufacturingCompany}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차종",
                    info: "${carName}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차량 번호",
                    info: "${carNumber}",
                    space: 120,
                  ),
                ],
              ),
            ),
          ),
        ),
        Footer(),
      ],
    );
  }
}
