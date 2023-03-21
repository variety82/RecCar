import 'package:flutter/material.dart';

class DamageLevelCard extends StatefulWidget {
  final int sideDamageLevel;

  const DamageLevelCard({
    super.key,
    required this.sideDamageLevel,
  });


  @override
  State<DamageLevelCard> createState() => _DamageLevelCardState();
}

class _DamageLevelCardState extends State<DamageLevelCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF999999).withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 6,
            )
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    width: 190,
                    child: Text(
                      '앞펜더 / 앞범퍼 / 전조등',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        width: 180,
                        height: 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFEFEFEF),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        width: 135,
                        height: 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 3
                    ),
                    child: Text(
                      '${widget.sideDamageLevel}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Text('건')
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}