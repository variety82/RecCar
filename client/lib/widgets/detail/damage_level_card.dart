import 'package:flutter/material.dart';

class DamageLevelCard extends StatefulWidget {
  final int damageLevel;
  final String partName;

  const DamageLevelCard({
    super.key,
    required this.damageLevel, required this.partName,
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
                  SizedBox(
                    width: 190,
                    child: Text(
                      widget.partName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
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
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        width: 180 * (widget.damageLevel / 4),
                        height: 13,
                        decoration: BoxDecoration(
                          borderRadius:
                            widget.damageLevel == 4
                              ? BorderRadius.circular(5)
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                            ),
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
                      '${widget.damageLevel}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  const Text('건')
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}