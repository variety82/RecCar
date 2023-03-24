import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:client/widgets/register/register_line.dart';
import 'package:client/widgets/register/register_title.dart';
import 'package:client/widgets/register/register_list.dart';
import 'package:client/screens/register/select_maker.dart';
import 'package:client/screens/register/select_car.dart';
import 'package:client/screens/register/select_fuel.dart';
import 'package:client/screens/register/select_date.dart';
import 'package:client/widgets/common/modal_navigator.dart';
import 'package:intl/intl.dart';
import 'package:client/services/register_api.dart';

class CarRegister extends StatefulWidget {
  const CarRegister({Key? key}) : super(key: key);

  @override
  State<CarRegister> createState() => _CarRegisterState();
}

class _CarRegisterState extends State<CarRegister> {
  // 선택한 제조사
  List<dynamic> carInfo = [];
  List<dynamic> manufacturerList = [];
  @override
  void initState() {
    super.initState();
    getCarInfo(
      success: (dynamic response) {
        setState(() {
          carInfo = response;
          manufacturerList = carInfo.map((maker) => maker['manufacturer']).toList();
        });
      },
      fail: (error) {
        print('차량 리스트 호출 오류: $error');
      },
    );
  }

  Map<String, dynamic> selectedMaker = {
    'id': null,
    'title': null,
  };

  Map<String, dynamic> selectedCar = {
    'id' : null,
    'title' : null,
  };

  Map<String, dynamic> selectedFuel = {
    'id' : null,
    'title' : null,
  };

  // 입력한 대여기간
  DateTime _borrowingDate = DateTime.now().add(const Duration(hours: 9));

  List<dynamic> carListByMaker = [];
  final bool _allregistered = false;

  // 제조사를 업데이트 해주는 function
  // parameter로 id와 이름을 받음
  void _updateSelectedMaker(makerId, makerTitle) {
    setState(() {
      // 선택되어 있는 제조사로 변경했을 경우
      if (selectedMaker['id'] == makerId) {
        // null값으로 변경
        selectedMaker = {
          'id': null,
          'title': null,
        };
        carListByMaker = [];
        // 선택되어 있는 제조사와 다른 값으로 변경했을 경우
      } else {
        // 새롭게 선택한 값으로 업데이트
        selectedMaker = {
          'id': makerId,
          'title': makerTitle,
        };
        selectedCar = {
          'id': null,
          'title': null,
        };
        carListByMaker = carInfo.firstWhere((maker) => maker['manufacturer']== makerTitle)['model'];
      }
    });
  }



  void _updateSelectedCar(carId, carName) {
    setState(() {
      // 선택되어 있는 제조사로 변경했을 경우
      if (selectedCar['id'] == carId) {
        // null값으로 변경
        selectedCar = {
          'id': null,
          'title': null,
        };
        // 선택되어 있는 제조사와 다른 값으로 변경했을 경우
      } else {
        // 새롭게 선택한 값으로 업데이트
        selectedCar = {
          'id': carId,
          'title': carName,
        };
      }
    });
  }

  void _updateSelectedFuel(fuelId, fuelName) {
    setState(() {
      // 선택되어 있는 제조사로 변경했을 경우
      if (selectedFuel['id'] == fuelId) {
        // null값으로 변경
        selectedFuel = {
          'id': null,
          'title': null,
        };
        // 선택되어 있는 제조사와 다른 값으로 변경했을 경우
      } else {
        // 새롭게 선택한 값으로 업데이트
        selectedFuel = {
          'id': fuelId,
          'title': fuelName,
        };
      }
    });
  }


  // 대여기간 업데이트
  void _updateSelectedDate(seletedDate) {
    setState(() {
      // 입력받은 DateTime타입의 값을 입력
      _borrowingDate = seletedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            const Header(title: '차량 등록'),
            // Header와 Footer 사이 공간
            Expanded(
              // 공간 전체 Padding
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 등록페이지의 제목 Class화
                    const RegisterTitle(title: '차량 정보'),
                    // 등록 페이지 목록 형식 Class화
                    RegisterList(
                      // 목록의 각각 줄들이 들어가는 paramater
                      lineList: [
                        // 모달 오픈하는 Custom Class
                        ModalNavigator(
                          // SelectMaker 위젯을 보여줌
                          showedWidget: SelectMaker(
                            updateSelectedMaker: _updateSelectedMaker,
                            manufacturerList : manufacturerList,
                          ),
                          disable: false,
                          // 클릭하는 영역
                          child: registerLine(
                            category: '제조사',
                            content: selectedMaker['title'] ?? '제조사를 선택해주세요',
                            isLastLine: false,
                            isSelected: selectedMaker['id'] != null,
                          ),
                        ),
                        ModalNavigator(
                          showedWidget: SelectCar(
                            updateSelectedCar: _updateSelectedCar,
                            carList : carListByMaker,
                            selectedMaker: selectedMaker,
                          ),
                          disable: selectedMaker['id'] == null,
                          child: registerLine(
                            category: '차종',
                            content:
                              selectedMaker['id'] == null
                                ? ''
                                : selectedCar['title'] ?? '차종을 선택해주세요',
                            isLastLine: false,
                            isSelected: selectedCar['id'] != null,
                          ),
                        ),
                        ModalNavigator(
                          // SelectMaker 위젯을 보여줌
                          showedWidget: SelectFuel(
                            updateSelectedFuel: _updateSelectedFuel,
                          ),
                          disable: false,
                          // 클릭하는 영역
                          child: registerLine(
                            category: '연료 종류',
                            content: selectedFuel['title'] ?? '연료 종류를 선택해주세요',
                            isLastLine: false,
                            isSelected: selectedFuel['id'] != null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const RegisterTitle(title: '대여 정보'),
                    RegisterList(
                      lineList: [
                        ModalNavigator(
                          showedWidget: SelectDate(
                            updateDate: _updateSelectedDate,
                          ),
                          disable: false,
                          child: registerLine(
                            category: '대여 일자',
                            content: DateFormat('yyyy년 MM월 dd일')
                                .format(_borrowingDate),
                            isLastLine: false,
                            isSelected: true,
                          ),
                        ),
                        ModalNavigator(
                          showedWidget: SelectDate(
                            updateDate: _updateSelectedDate,
                          ),
                          disable: false,
                          child: registerLine(
                            category: '대여 일자',
                            content: DateFormat('yyyy년 MM월 dd일')
                                .format(_borrowingDate),
                            isLastLine: false,
                            isSelected: true,
                          ),
                        ),
                        const registerLine(
                          category: '렌트카 업체',
                          content: 'SSAFY',
                          isLastLine: false,
                          isSelected: false,
                        ),
                        const registerLine(
                          category: '차량 번호',
                          content: '00허 2102',
                          isLastLine: true,
                          isSelected: false,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: ElevatedButton(
                            onPressed:
                              _allregistered
                                ? () {
                                    //  나중에 등록 메소드 추가
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor
                            ),
                            child: const SizedBox(
                                width: 70,
                                child: Text(
                                  '등록하기',
                                  textAlign: TextAlign.center,
                                ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Footer()
          ],
        ));
  }
}
