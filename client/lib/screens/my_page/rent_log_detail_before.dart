import 'package:flutter/material.dart';
import '../../widgets/my_page/damage_log_card.dart';

class BeforeRent extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String rentCompany;
  final String manufacturingCompany;
  final String carName;
  final String carNumber;
  final int id;

  const BeforeRent({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.rentCompany,
    required this.manufacturingCompany,
    required this.carName,
    required this.carNumber,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(children: [
                  for (int i = 0; i < 7; i++)
                    DamageLogCard(
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLF9LLlP2p2PEAlUdOMIc_5fuqi6wh15ch7A&usqp=CAU",
                      kindOfDamage: "스크래치",
                      damageLocation: "범퍼",
                      id: i,
                    ),
                ])),
          ),
        ),
        const Divider(
          height: 5,
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Color(0xFFD8D8D8),
        ),
        SizedBox(height: 20),
        Flexible(
          flex: 2,
          child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "대여 일자",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$startDate",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "반납 일자",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$endDate",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "렌트카 업체",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$rentCompany",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "제조사",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$manufacturingCompany",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "차종",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$carName",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          "차량 번호",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "$carNumber",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
