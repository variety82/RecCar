import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_go_detail.dart';

class CheckCarDamageDetail extends StatefulWidget {
  // final void Function(String) addCategories;
  // final void Function(String) removeCategories;
  // final List<String> selected_categories;
  final String imageUrl;

  const CheckCarDamageDetail({
    super.key,
    required this.imageUrl,
    // required this.selected_categories,
    // required this.addCategories,
    // required this.removeCategories,
  });

  @override
  State<CheckCarDamageDetail> createState() => _CheckCarDamageDetailState();
}

class _CheckCarDamageDetailState extends State<CheckCarDamageDetail> {
  String part = '';
  int scratch_count = 0;
  int crushed_count = 0;
  int breakage_count = 0;
  int separated_count = 0;

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
                    '손상 사진',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ImageGoDetail(
                      imageUrl: widget.imageUrl,
                    ),
                  ),
                  Text(
                    '손상 종류',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '스크래치',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (scratch_count > 0) {
                                          setState(() {
                                            scratch_count--;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text('${scratch_count}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          scratch_count++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '찌그러짐',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (crushed_count > 0) {
                                          setState(() {
                                            crushed_count--;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text('${crushed_count}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          crushed_count++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '파손',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (breakage_count > 0) {
                                          setState(() {
                                            breakage_count--;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text('${breakage_count}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          breakage_count++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '이격',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (separated_count > 0) {
                                          setState(() {
                                            separated_count--;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text('${separated_count}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          separated_count++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            '차량 부위',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 5,
                            children: part_categories.map(
                              (part_category) {
                                return InkWell(
                                  onTap: () {
                                    if (part == part_category) {
                                      setState(() {
                                        part = '';
                                      });
                                    } else {
                                      setState(() {
                                        part = part_category;
                                      });
                                    }
                                  },
                                  child: Chip(
                                      label: Text(
                                        part_category,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      labelPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      backgroundColor: (part == part_category)
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
