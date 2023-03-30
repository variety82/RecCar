import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';
import 'package:client/widgets/register/maker_item.dart';
import 'package:client/services/register_api.dart';

class SelectMaker extends StatefulWidget {
  final void Function(int, String, String) updateSelectedMaker;
  final List<dynamic> carInfo;

  const SelectMaker({
    super.key, required this.updateSelectedMaker, required this.carInfo,
  });

  @override
  State<SelectMaker> createState() => _SelectMakerState();
}

class _SelectMakerState extends State<SelectMaker> {
  /*
  selectedItem에는 선택되는 제조사의 id가 들어간다
  isSelected는 만약 makerId가 selectedItem이 같을 때 true가 되도록 한다.
   */
  
  // 선택된 제조사의 ID 값이 들어간다

  int? selectedMaker;

  void _changeSelectedItem(itemId) {
    setState(() {
      if (selectedMaker == itemId) {
        // 선택한 제조사가 현재 선택된 제조사일 경우 null값으로 변경
        selectedMaker = null;
      } else {
        // 다를 경우 해당 제조사 ID로 selectedMaker 변경
        selectedMaker = itemId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modal Bar
        Container(
          margin: const EdgeInsets.only(
            top: 7,
            bottom: 3,
          ),
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryTitle(
                      title: '제조사',
                      isSelected: true
                  ),
                  CategoryTitle(
                      title: '차종',
                      isSelected: false
                  ),
                  CategoryTitle(
                      title: '연료',
                      isSelected: false
                  ),
                ],
              ),
            ),
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
            '제조사를 선택해주세요.',
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
              direction: Axis.horizontal,
              // asmap은 Map에 index 넣는 것이고 entries는 key value값의 맵으로 값 바꿔주는 것
              // 그러면 maker값이 index와 makerInfo로 나누어진다
              // map은 말그대로 map이다 children에는 list가 들어가야 하기 때문에 toList()를 해준다
              children: widget.carInfo.asMap().entries.map<MakerItem>((MapEntry<int, dynamic> makerList) {
                int index = makerList.key;
                Map<String, dynamic> maker = makerList.value;
                return MakerItem(
                    updateSelectedMaker: widget.updateSelectedMaker,
                    changeSelectedItem: _changeSelectedItem,
                    isSelected: selectedMaker == index ? true : false,
                    makerId: index,
                    makerTitle: maker['manufacturer'],
                    makerLogoUrl: maker['logoUrl'],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}