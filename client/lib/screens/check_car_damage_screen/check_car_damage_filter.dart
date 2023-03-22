import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class CheckCarDamagefilter extends StatefulWidget {
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

  List<String> selected_categories = [];

  void removeCategories(String categoryName) {
    selected_categories.remove(categoryName);
    setState(() {});
  }

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
                            if (selected_categories.contains(damage_category)) {
                              setState(() {
                                selected_categories.remove(damage_category);
                              });
                            } else {
                              setState(() {
                                selected_categories.add(damage_category);
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
                              backgroundColor:
                                  selected_categories.contains(damage_category)
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
                            if (selected_categories.contains(part_category)) {
                              setState(() {
                                selected_categories.remove(part_category);
                              });
                            } else {
                              setState(() {
                                selected_categories.add(part_category);
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
                              backgroundColor:
                                  selected_categories.contains(part_category)
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selected_categories.map(
                        (category) {
                          return Chip(
                            onDeleted: () {
                              removeCategories(category);
                              print(category);
                            },
                            deleteIcon: const Icon(
                              Icons.clear_rounded,
                              size: 16,
                            ),
                            label: Text(
                              category,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            labelPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            backgroundColor: Color(0xFFFBD5DC),
                            deleteIconColor: Color(0xFFE0426F),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  if (selected_categories.isEmpty)
                    Container(
                      height: 80,
                      child: const Center(
                        child: Text('현재 적용된 필터링이 없습니다.'),
                      ),
                    ),
                ],
              )),
        ],
      ),
    );
  }
}

// Center(
//   child: GestureDetector(
//     child: Hero(
//       tag: 'imageHero',
//       child: Column(
//         children: [
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//         ],
//       ),
//     ),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) {
//             return ImageScreen(
//                 imageUrl:
//                     'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg');
//           },
//         ),
//       );
//     },
//   ),
// ),
