import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/car_info_table_row.dart';

class CarInfo extends StatelessWidget {
  const CarInfo({Key? key}) : super(key: key);

  void editCarInfo() {}

  void editRentInfo() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Header(
            title: '차량 정보 조회',
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Column(
              children: [
                // 차량 정보
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "차량 정보",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            TextButton(
                              onPressed: editCarInfo,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0426F),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "편집",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFD8D8D8),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            CarInfoTableRow(rowName: "제조사", rowInfo: "르노 삼성"),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            CarInfoTableRow(rowName: "차종", rowInfo: "SM5"),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            CarInfoTableRow(rowName: "연료 종류", rowInfo: "경유"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 수정 완료 버튼 (편집 누르면 활성화)
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: TextButton(
                    onPressed: editRentInfo,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0426F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "수정 완료",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // 대여 정보
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "대여 정보",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            TextButton(
                              onPressed: editRentInfo,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0426F),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "편집",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFD8D8D8),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            CarInfoTableRow(
                                rowName: "대여 일자", rowInfo: "2023.03.09 10:00"),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            CarInfoTableRow(
                                rowName: "반납 일자", rowInfo: "2022.03.10 13:00"),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            CarInfoTableRow(rowName: "렌트카 업체", rowInfo: "그린카"),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            CarInfoTableRow(
                                rowName: "차량 번호", rowInfo: "38모 6715"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 수정 완료 버튼 (편집 누르면 활성화)
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: TextButton(
                    onPressed: editRentInfo,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0426F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "수정 완료",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
