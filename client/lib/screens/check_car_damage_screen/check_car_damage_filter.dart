import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class CheckCarDamagefilter extends StatefulWidget {
  final void Function(String) addCategories;
  final void Function(String) removeCategories;
  final List<String> selected_categories;

  const CheckCarDamagefilter({
    super.key,
    required this.selected_categories,
    required this.addCategories,
    required this.removeCategories,
  });

  @override
  State<CheckCarDamagefilter> createState() => _CheckCarDamagefilterState();
}

class _CheckCarDamagefilterState extends State<CheckCarDamagefilter> {
  List<String> damage_categories = [
    '스크래치',
    '찌그러짐',
    '파손',
    '이격',
  ];

  List<String> part_categories = [
    '앞범퍼/앞펜더/전조등',
    '뒷범퍼/뒷펜더/후미등',
    '옆면/사이드/스텝',
    '타이어/휠',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    '손상 종류',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: damage_categories.map(
                      (damage_category) {
                        return InkWell(
                          onTap: () {
                            if (widget.selected_categories
                                .contains(damage_category)) {
                              widget.removeCategories(damage_category);
                              setState(() {
                                widget.selected_categories;
                              });
                            } else {
                              widget.addCategories(damage_category);
                              setState(() {
                                widget.selected_categories;
                              });
                            }
                          },
                          child: Chip(
                              label: Text(
                                damage_category,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              labelPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              backgroundColor: widget.selected_categories
                                      .contains(damage_category)
                                  ? Color(0xFFFBD5DC)
                                  : Colors.grey
                              // deleteIconColor: Color(0xFFE0426F),
                              ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              )),
          // Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Column(
          //       children: [
          //         Text(
          //           '차량 부위',
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w700,
          //             color: Colors.black,
          //           ),
          //         ),
          //         Wrap(
          //           spacing: 10,
          //           runSpacing: 5,
          //           children: part_categories.map(
          //             (part_category) {
          //               return InkWell(
          //                 onTap: () {
          //                   if (widget.selected_categories
          //                       .contains(part_category)) {
          //                     setState(() {
          //                       widget.removeCategories(part_category);
          //                       // widget.selected_categories
          //                       //     .remove(part_category);
          //                     });
          //                   } else {
          //                     setState(() {
          //                       widget.addCategories(part_category);
          //                       // widget.selected_categories.add(part_category);
          //                     });
          //                   }
          //                 },
          //                 child: Chip(
          //                     label: Text(
          //                       part_category,
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                       ),
          //                     ),
          //                     labelPadding: EdgeInsets.symmetric(
          //                       horizontal: 8,
          //                     ),
          //                     backgroundColor: widget.selected_categories
          //                             .contains(part_category)
          //                         ? Color(0xFFFBD5DC)
          //                         : Colors.grey
          //                     // deleteIconColor: Color(0xFFE0426F),
          //                     ),
          //               );
          //             },
          //           ).toList(),
          //         ),
          //       ],
          //     )),
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: Column(
          //     children: [
          //       Text(
          //         '현재 필터링',
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //           color: Colors.black,
          //         ),
          //       ),
          //       SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Wrap(
          //           spacing: 10,
          //           runSpacing: 10,
          //           children: widget.selected_categories.map(
          //             (category) {
          //               return Chip(
          //                 onDeleted: () {
          //                   setState(() {
          //                     widget.removeCategories(category);
          //                   });
          //                   print(category);
          //                 },
          //                 deleteIcon: const Icon(
          //                   Icons.clear_rounded,
          //                   size: 16,
          //                 ),
          //                 label: Text(
          //                   category,
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                   ),
          //                 ),
          //                 labelPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          //                 backgroundColor: Color(0xFFFBD5DC),
          //                 deleteIconColor: Color(0xFFE0426F),
          //               );
          //             },
          //           ).toList(),
          //         ),
          //       ),
          //       if (widget.selected_categories.isEmpty)
          //         Container(
          //           height: 60,
          //           child: const Center(
          //             child: Text('현재 적용된 필터링이 없습니다.'),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
