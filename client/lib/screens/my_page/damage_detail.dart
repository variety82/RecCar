import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
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
          Header(title: "렌트 내역"),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLF9LLlP2p2PEAlUdOMIc_5fuqi6wh15ch7A&usqp=CAU")),
                    ),
                  ),
                  const Divider(
                    height: 40,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Color(0xFFD8D8D8),
                  ),
                  Container(
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "2021.10.20 10:00",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "2021.10.23 17:00",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "쏘카",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "현대",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "소나타",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                    "38모 6715",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
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
