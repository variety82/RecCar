import 'package:flutter/material.dart';

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
                const Text(
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
                    (damageCategory) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (widget.selected_categories
                              .contains(damageCategory)) {
                            widget.removeCategories(damageCategory);
                            setState(() {
                              widget.selected_categories;
                            });
                          } else {
                            widget.addCategories(damageCategory);
                            setState(() {
                              widget.selected_categories;
                            });
                          }
                        },
                        child: Chip(
                            label: Text(
                              damageCategory,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            backgroundColor: widget.selected_categories
                                    .contains(damageCategory)
                                ? const Color(0xFFFBD5DC)
                                : Colors.grey
                            // deleteIconColor: Color(0xFFE0426F),
                            ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
