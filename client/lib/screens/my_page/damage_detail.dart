import 'package:flutter/material.dart';
import '../../widgets/my_page/rent_log_line.dart';
import '../../widgets/common/footer.dart';

class DamageDetail extends StatelessWidget {
  final int id;

  const DamageDetail({
    super.key,
    required this.id,
  });

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
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLF9LLlP2p2PEAlUdOMIc_5fuqi6wh15ch7A&usqp=CAU")),
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
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RentLogLine(
                            infoTitle: "파손 일자",
                            info: "2021.02.03",
                            space: 120,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RentLogLine(
                            infoTitle: "파손 종류",
                            info: "스크래치",
                            space: 120,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RentLogLine(
                            infoTitle: "파손 부위",
                            info: "앞 범퍼",
                            space: 120,
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
