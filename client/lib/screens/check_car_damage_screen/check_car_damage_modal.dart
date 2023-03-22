import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';
import 'package:client/widgets/register/maker_item.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter.dart';

class CheckCarDamageModal extends StatefulWidget {
  // final void Function(int, String) updateSelectedItem;
  // final Widget showedWidget;

  const CheckCarDamageModal({
    super.key,
    // required this.updateSelectedItem,
    // required this.showedWidget,
  });

  @override
  State<CheckCarDamageModal> createState() => _CheckCarDamageModal();
}

class _CheckCarDamageModal extends State<CheckCarDamageModal> {
  /*
  selectedItem에는 선택되는 제조사의 id가 들어간다
  isSelected는 만약 makerId가 selectedItem이 같을 때 true가 되도록 한다.
   */

  // // 선택된 제조사의 ID 값이 들어간다
  // int? selectedItem;
  //
  // void _changeSelectedItem(itemId) {
  //   setState(() {
  //     if (selectedItem == itemId) {
  //       // 선택한 제조사가 현재 선택된 제조사일 경우 null값으로 변경
  //       selectedItem = null;
  //     } else {
  //       // 다를 경우 해당 제조사 ID로 selectedMaker 변경
  //       selectedItem = itemId;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
            child: CheckCarDamagefilter(),
          ),
        ],
      ),
    );
  }
}
