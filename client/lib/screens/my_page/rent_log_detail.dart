import 'package:client/screens/my_page/rent_log_detail_after.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/rent_log_line.dart';
import './rent_log_detail_before.dart';
import 'package:client/services/my_page_api.dart';
import 'package:characters/characters.dart';

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
  dynamic simpleDamageInfo = [];
  dynamic beforeDamage =  List<Map<String, dynamic>>.filled(0, {}, growable: true);
  dynamic afterDamage = List<Map<String, dynamic>>.filled(0, {}, growable: true);

  @override
  void initState() {
    super.initState();
    getDetailRentInfo(
      success: (dynamic response) {
        setState(() {
          print(detailRentInfo.runtimeType);
          detailRentInfo = response;
          print(response.runtimeType);
          print(detailRentInfo.runtimeType);
        });
      },
      fail: (error) {
        print('렌트 상세 내역 호출 오류: $error');
      },
      carId: widget.carId,
    );

    getSimpleDamageInfo(
      success: (dynamic response) {
        setState(() {
          simpleDamageInfo = response;
        });
        for(int i = 0; i < response.length; i++) {
          if(response[i]['former']) {
            beforeDamage.add(response[i]);
          }
          else {
            afterDamage.add(response[i]);
          }
        }
      },
      fail: (error) {
        print('렌트 상세 내역 호출 오류: $error');
      },
      carId: widget.carId,
    );
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
                  BeforeRent(before: beforeDamage,),
                  AfterRent(after: afterDamage,),
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
                    info: detailRentInfo['rentalDate'].toString().characters.take(10).toString(),
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "반납 일자",
                    info: detailRentInfo['returnDate'].toString().characters.take(10).toString(),
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "대여 업체",
                    info: "${detailRentInfo['rentalCompany']}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "제조사",
                    info: "${detailRentInfo['carManufacturer']}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차종",
                    info: "${detailRentInfo['carModel']}",
                    space: 120,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RentLogLine(
                    infoTitle: "차량 번호",
                    info: "${detailRentInfo['carNumber']}",
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
