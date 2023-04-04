import 'package:flutter/material.dart';
import '../../screens/my_page/damage_detail.dart';
import './rent_log_line.dart';
import '../../services/my_page_api.dart';

class DamageLogCard extends StatefulWidget {
  final String imageUrl;
  final String kindOfDamage;
  final String damageLocation;
  final String damageDate;
  final String memo;
  final int damageId;

  const DamageLogCard({
    super.key,
    required this.imageUrl,
    required this.kindOfDamage,
    required this.damageLocation,
    required this.damageDate,
    required this.memo,
    required this.damageId,
  });

  @override
  State<DamageLogCard> createState() => _DamageLogCardState();
}

class _DamageLogCardState extends State<DamageLogCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DamageDetail(
              damageImageUrl: widget.imageUrl,
              damageDate: widget.damageDate,
              damagaLocation: widget.damageLocation,
              kindOfDamage: widget.kindOfDamage,
              memo: widget.memo,
            ),
          ),
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
                    padding: EdgeInsets.all(15),
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
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                              )
                            ],
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage("${widget.imageUrl}")),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RentLogLine(
                              infoTitle: "파손 일자",
                              info: widget.damageDate.toString().substring(0, 10),
                              space: 70,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RentLogLine(
                              infoTitle: "파손 부위",
                              info: "${widget.damageLocation}",
                              space: 70,
                            ),
                            Divider(
                              thickness: 1.5,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "자세히 보기",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                          ],
                        )
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
        ),
      ),
    );
  }
}
