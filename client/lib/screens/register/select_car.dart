import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';
import 'package:client/widgets/register/maker_item.dart';

class SelectCar extends StatefulWidget {
  const SelectCar({
    super.key,
  });

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  /*
  selectedItem에는 선택되는 제조사의 id가 들어간다
  isSelected는 만약 makerId가 selectedItem이 같을 때 true가 되도록 한다.
   */

  // 선택된 제조사의 ID 값이 들어간다
  // int? selectedMaker;
  // void _changeSelectedItem(itemId) {
  //   setState(() {
  //     if (selectedMaker == itemId) {
  //       // 선택한 제조사가 현재 선택된 제조사일 경우 null값으로 변경
  //       selectedMaker = null;
  //     } else {
  //       // 다를 경우 해당 제조사 ID로 selectedMaker 변경
  //       selectedMaker = itemId;
  //     }
  //   });
  // }

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
        const Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20
          ),
          // 카테고리 리스트, 현재는 선택해서 이동 불가하고 시간 남으면 클릭시 모달 내용 변경하도록 설정
          child: Row(
            children: [
              categoryTitle(
                  title: '제조사',
                  isSelected: false
              ),
              categoryTitle(
                  title: '차종',
                  isSelected: true
              ),
              categoryTitle(
                  title: '연료',
                  isSelected: false
              ),
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
        // 제조사 선택 Body의 제목
        Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 30,
          ) ,
          child: Text(
            '차종를 선택해주세요.',
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // 제조사 선택 영역이 나열될 곳
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.vertical,
              children: [
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
                Text('그렌저'),
              ],
            ),
          ),
        )
      ],
    );
  }
}
