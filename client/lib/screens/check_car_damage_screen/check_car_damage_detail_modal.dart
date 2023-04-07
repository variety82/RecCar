import 'package:flutter/material.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_detail.dart';

class CheckCarDamageDetailModal extends StatefulWidget {
  // final void Function(String) addCategories;
  // final void Function(String) removeCategories;
  // final List<String> selected_categories;
  final String imageUrl;
  final String modalCase;
  final Map<String, dynamic> carDamage;
  final void Function(int, String, int, int, int, int, String)
      changeDamageValue;

  const CheckCarDamageDetailModal({
    super.key,
    required this.imageUrl,
    required this.modalCase,
    required this.carDamage,
    required this.changeDamageValue,
    // required this.selected_categories,
    // required this.addCategories,
    // required this.removeCategories,
  });

  @override
  State<CheckCarDamageDetailModal> createState() =>
      _CheckCarDamageDetailModalState();
}

class _CheckCarDamageDetailModalState extends State<CheckCarDamageDetailModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CategoryTitle(title: '필터링 설정', isSelected: true),
              Text(
                widget.modalCase,
                style: const TextStyle(
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
        Expanded(
          child: CheckCarDamageDetail(
            carDamage: widget.carDamage,
            changeDamageValue: widget.changeDamageValue,
            imageUrl: widget.imageUrl,
            modalCase: widget.modalCase,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        )
      ],
    );
  }
}
