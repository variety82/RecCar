import 'package:flutter/material.dart';
import '../../widgets/my_page/rent_log_line.dart';
import '../../widgets/common/footer.dart';
import '../../services/my_page_api.dart';

class DamageDetail extends StatefulWidget {
  final damageImageUrl;
  final damageDate;
  final kindOfDamage;
  final damagaLocation;
  final memo;

  const DamageDetail({
    super.key,
    required this.damageImageUrl,
    required this.damageDate,
    required this.kindOfDamage,
    required this.damagaLocation,
    required this.memo,
  });

  @override
  State<DamageDetail> createState() => _DamageDetailState();
}

class _DamageDetailState extends State<DamageDetail> {
  Map<String, dynamic> detailDamageInfo = {};
  // @override
  // void initState() {
  //   super.initState();
  //   getDetailDamageInfo(
  //     success: (dynamic response) {
  //       setState(() {
  //         detailDamageInfo = response;
  //       });
  //       print(response);
  //     },
  //     fail: (error) {
  //       print('렌트 내역 호출 오류: $error');
  //     },
  //     damageId: widget.damageId,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 90,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "${widget.damageImageUrl}")),
                    ),
                  ),
                  // const Divider(
                  //   height: 40,
                  //   thickness: 1.5,
                  //   indent: 20,
                  //   endIndent: 20,
                  //   color: Color(0xFFD8D8D8),
                  // ),
                  Container(
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
                            "손상 정보",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RentLogLine(
                            infoTitle: "파손 일자",
                            info: widget.damageDate.toString().substring(0, 10),
                            space: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RentLogLine(
                            infoTitle: "파손 종류",
                            info: "${widget.kindOfDamage}",
                            space: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RentLogLine(
                            infoTitle: "파손 부위",
                            info: "${widget.damagaLocation}",
                            space: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RentLogLine(
                            infoTitle: "메모",
                            info: "${widget.memo}",
                            space: 100,
                          ),
                        ],
                      ),
                    ),
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
