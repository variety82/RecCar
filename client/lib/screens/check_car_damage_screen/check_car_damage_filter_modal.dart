import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';
import 'package:client/widgets/register/maker_item.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter.dart';

class CheckCarDamageFilterModal extends StatefulWidget {
  final void Function(String) addCategories;
  final void Function(String) removeCategories;
  final List<String> selected_categories;

  const CheckCarDamageFilterModal({
    super.key,
    required this.selected_categories,
    required this.addCategories,
    required this.removeCategories,
  });

  @override
  State<CheckCarDamageFilterModal> createState() =>
      _CheckCarDamageFilterModalState();
}

class _CheckCarDamageFilterModalState extends State<CheckCarDamageFilterModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          // Modal Bar
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 50,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color(0xFFEFEFEF),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CategoryTitle(title: '필터링 설정', isSelected: true),
                Text(
                  '필터링 설정',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          // 카테고리 하단 바
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 1,
            color: const Color(0xFFEFEFEF),
          ),
          Container(
            width: double.infinity,
            child: CheckCarDamagefilter(
              selected_categories: widget.selected_categories,
              addCategories: widget.addCategories,
              removeCategories: widget.removeCategories,
            ),
          ),
        ],
      ),
    );
  }
}
