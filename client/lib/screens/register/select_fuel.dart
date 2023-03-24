import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';

class SelectFuel extends StatefulWidget {

  final void Function(int, String) updateSelectedFuel;

  const SelectFuel({
    super.key, required this.updateSelectedFuel,
  });

  @override
  State<SelectFuel> createState() => _SelectFuelState();
}

class _SelectFuelState extends State<SelectFuel> {
  /*
  selectedItem에는 선택되는 제조사의 id가 들어간다
  isSelected는 만약 makerId가 selectedItem이 같을 때 true가 되도록 한다.
   */

  // 선택된 제조사의 ID 값이 들어간다
  int? selectedFuel;
  void _changeSelectedFuel(fuelId) {
    setState(() {
      if (selectedFuel == fuelId) {
        // 선택한 제조사가 현재 선택된 제조사일 경우 null값으로 변경
        selectedFuel = null;
      } else {
        // 다를 경우 해당 제조사 ID로 selectedMaker 변경
        selectedFuel = fuelId;
        print(fuelId);
      }
    });
  }

  List<String> fuelList = ['가솔린', '디젤', '전기', '하이브리드'];


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
          child: Row(
            children: [
              CategoryTitle(
                  title: '제조사',
                  isSelected: false
              ),
              CategoryTitle(
                  title: '차종',
                  isSelected: false
              ),
              CategoryTitle(
                  title: '연료',
                  isSelected: true
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
            '연료 종류를 선택해주세요.',
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
              children: fuelList.asMap().entries.map<Widget>((MapEntry<int, dynamic> car) {
                int index = car.key;
                String carName = car.value;
                return InkWell(
                  onTap: () {
                    setState(() {
                      widget.updateSelectedFuel(index, carName);
                      _changeSelectedFuel(index);
                    });
                  }
                  ,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10
                    ),
                    width: 180,
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          '$carName',
                          style: TextStyle(
                              fontWeight: selectedFuel == index ? FontWeight.w600 : FontWeight.w400,
                              color: selectedFuel == index ? Theme.of(context).secondaryHeaderColor : Theme.of(context).disabledColor
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
