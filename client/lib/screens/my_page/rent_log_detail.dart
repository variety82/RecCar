import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/rent_log_line.dart';
import './rent_log_detail_before.dart';
import 'package:client/screens/my_page/rent_log_detail_after.dart';
import 'package:client/services/my_page_api.dart';

class RentLogDetail extends StatefulWidget {
  final int carId;

  const RentLogDetail({
    super.key,
    required this.carId,
  });

  @override
  State<RentLogDetail> createState() => _RentLogDetailState();
}

class _RentLogDetailState extends State<RentLogDetail> {
  Map<String, dynamic> detailRentInfo = {};
  Map<String, dynamic> simpleDamageInfo = {};

  @override
  void initState() {
    getSimpleDamageInfo(
      success: (dynamic response) {
        setState(() {
          simpleDamageInfo = response;
        });
      },
      fail: (error) {
        print('파손 상세 내역 호출 오류: $error');
      },
      carId: widget.carId,
    );
    getDetailRentInfo(
      success: (dynamic response) {
        setState(() {
          detailRentInfo = response;
        });
      },
      fail: (error) {
        print('렌트 상세 내역 호출 오류: $error');
      },
      carId: widget.carId,
    );
    super.initState();
  }

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
                  BeforeRent(
                    before: simpleDamageInfo['initialDetectionInfos'] ?? [],
                  ),
                  AfterRent(
                    after: simpleDamageInfo['latterDetectionInfos'] ?? [],
                  ),
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
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RentLogLine(
                    infoTitle: "대여 일자",
                    info: simpleDamageInfo['rentalDate'] ?? "",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "반납 일자",
                    info: simpleDamageInfo['returnDate'] ?? "",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "대여 업체",
                    info: simpleDamageInfo['rentalCompany'] ?? "",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "제조사",
                    info: simpleDamageInfo['carManufacturer'] ?? "",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차종",
                    info: simpleDamageInfo['carModel'] ?? "",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차량 번호",
                    info: simpleDamageInfo['carNumber'] ?? "",
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
