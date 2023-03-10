import 'package:flutter/material.dart';
import '../../screens/my_page/rent_log_detail.dart';


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
          MaterialPageRoute(builder: (context) => RentLogDetail(id: id,)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$startDate ~ $endDate",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "- $company",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "- 총 $damage개의 파손 발견",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
        ],
      )),
    );
  }
}
