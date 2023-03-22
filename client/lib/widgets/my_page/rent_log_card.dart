import 'package:flutter/material.dart';
import '../../screens/my_page/rent_log_detail.dart';
import './rent_log_line.dart';

class RentLogCard extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String company;
  final int damage;
  final int id;

  const RentLogCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.company,
    required this.damage,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RentLogDetail(
                    id: id,
                    startDate: "2021.11.26",
                    endDate: "2021.11.27",
                    rentCompany: "그린카",
                    manufacturingCompany: "현대",
                    carName: "그렌저",
                    carNumber: "38모 6715",
                  )),
        );
      },
      child: Container(
          child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RentLogLine(infoTitle: "대여 일자", info: "${startDate}", space: 100,),
                        SizedBox(
                          height: 5,
                        ),
                        RentLogLine(infoTitle: "반납 일자", info: "${endDate}", space: 100,),
                        SizedBox(
                          height: 5,
                        ),
                        RentLogLine(infoTitle: "대여 업체", info: "${company}", space: 100,),
                        SizedBox(
                          height: 5,
                        ),
                        RentLogLine(infoTitle: "파손 개수", info: "${damage} 개", space: 100,),
                        Divider(
                          thickness: 1.5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "자세히 보기",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
        ],
      )),
    );
  }
}
