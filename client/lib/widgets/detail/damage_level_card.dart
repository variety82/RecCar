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
  bool _isExpanded = false;


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
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
                        const Text('건'),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        SizedBox(
                          width: 40,
                          child: Icon(
                            !_isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                            color: Theme.of(context).secondaryHeaderColor,
                            // size: 40,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              if (_isExpanded)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFEFEFEF),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: Image.network(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtHU4BqZcNHPKDPWdn28TYFjpJWWNhZvUvWQ&usqp=CAU', // 이미지 URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(7)
                                  )
                                ),
                                child: Text(
                                  '스크래치',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '2023.03.03 18:30',
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),

      ),
    );
  }
}