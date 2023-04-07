import 'package:flutter/material.dart';
import 'package:client/widgets/common/header.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:client/widgets/register/register_line.dart';
import 'package:client/widgets/register/register_title.dart';
import 'package:client/widgets/register/register_list.dart';
import 'package:client/screens/register/select_maker.dart';
import 'package:client/screens/register/select_car.dart';
import 'package:client/screens/register/select_fuel.dart';
import 'package:client/screens/register/select_borrow_date.dart';
import 'package:client/screens/register/select_return_date.dart';
import 'package:intl/intl.dart';
import 'package:client/services/register_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CarRegister extends StatefulWidget {
  const CarRegister({Key? key}) : super(key: key);

  @override
  State<CarRegister> createState() => _CarRegisterState();
}

class _CarRegisterState extends State<CarRegister> {
  final FocusNode _rentalCompanyFocusNode = FocusNode();
  final FocusNode _carNumberFocusNode = FocusNode();
  final storage = const FlutterSecureStorage();

  // 선택한 제조사
  List<dynamic> carInfo = [];
  bool _allRegistered = false;

  int? categorySelected;

  @override
  void initState() {
    super.initState();
    getCarInfo(
      success: (dynamic response) {
        setState(() {
          carInfo = response;
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
    'logoUrl': null,
  };

  Map<String, dynamic> selectedCar = {
    'id': null,
    'title': null,
  };

  Map<String, dynamic> selectedFuel = {
    'id': null,
    'title': null,
  };

  // 입력한 대여기간
  DateTime _borrowingDate = DateTime.now().add(const Duration(hours: 9));

  DateTime _returnDate = DateTime.now().add(const Duration(hours: 9));

  bool _isValidatedDate = true;

  String _inputedRentalCompany = '';

  String _inputedCarNumber = '';

  List<dynamic> carListByMaker = [];

  Map<String, dynamic> _buildCarInfoBody() {
    return {
      "userId": 1,
      "carNumber": _inputedCarNumber,
      "carManufacturer": selectedMaker['title'],
      "carModel": selectedCar['title'],
      "carFuel": selectedFuel['title'],
      "rentalDate":
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(_borrowingDate),
      "returnDate":
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(_returnDate),
      "rentalCompany": _inputedRentalCompany,
      "initialVideo": "rental.mp4"
    };
  }

  void _updateAllRegistered() {
    setState(() {
      if (selectedMaker['id'] != null &&
          selectedCar['id'] != null &&
          selectedFuel['id'] != null &&
          _inputedRentalCompany.isNotEmpty &&
          _inputedCarNumber.isNotEmpty &&
          _isValidatedDate) {
        _allRegistered = true;
      } else {
        _allRegistered = false;
      }
    });
  }

  // 제조사를 업데이트 해주는 function
  // parameter로 id와 이름을 받음
  void _updateSelectedMaker(
      int makerId, String makerTitle, String makerLogoUrl) {
    setState(() {
      // 선택되어 있는 제조사로 변경했을 경우
      if (selectedMaker['id'] == makerId) {
        // null값으로 변경
        selectedMaker = {
          'id': null,
          'title': null,
          'logoUrl': null,
        };
        carListByMaker = [];
        // 선택되어 있는 제조사와 다른 값으로 변경했을 경우
      } else {
        // 새롭게 선택한 값으로 업데이트
        selectedMaker = {
          'id': makerId,
          'title': makerTitle,
          'logoUrl': makerLogoUrl,
        };
        selectedCar = {
          'id': null,
          'title': null,
          'logoUrl': null,
        };
        carListByMaker = carInfo.firstWhere(
            (maker) => maker['manufacturer'] == makerTitle)['model'];
      }
      _updateAllRegistered();
    });
  }

  void _updateSelectedCar(int carId, String carName) {
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
      _updateAllRegistered();
    });
  }

  void _updateSelectedFuel(int fuelId, String fuelName) {
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
      _updateAllRegistered();
    });
  }

  // 대여기간 업데이트
  void _updateBorrowingDate(DateTime selectedDate) {
    setState(() {
      // 입력받은 DateTime타입의 값을 입력
      _borrowingDate = selectedDate;
      _isValidatedDate = _returnDate.isAtSameMomentAs(_borrowingDate) ||
          _returnDate.isAfter(_borrowingDate);
      _updateAllRegistered();
    });
  }

  void _updateReturnDate(DateTime selectedDate) {
    setState(() {
      // 입력받은 DateTime타입의 값을 입력
      _returnDate = selectedDate;
      _isValidatedDate = _returnDate.isAtSameMomentAs(_borrowingDate) ||
          _returnDate.isAfter(_borrowingDate);
      _updateAllRegistered();
    });
  }

  void _updateInputRentalCompany(String rentalCompany) {
    setState(() {
      _inputedRentalCompany = rentalCompany;
      _updateAllRegistered();
    });
  }

  void _updateInputCarNumber(String carNumber) {
    setState(() {
      _inputedCarNumber = carNumber;
      _updateAllRegistered();
    });
  }

  bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  void _showModal(BuildContext context, int? modalIndex) {
    if (modalIndex == 2 && selectedMaker['id'] == null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        Widget child;
        switch (modalIndex) {
          case 1:
            child = SelectMaker(
              selectedMaker: selectedMaker,
              updateSelectedMaker: _updateSelectedMaker,
              carInfo: carInfo,
              showModal: _showModal,
            );
            break;
          case 2:
            child = SelectCar(
              updateSelectedCar: _updateSelectedCar,
              carList: carListByMaker,
              selectedMaker: selectedMaker,
              selectedCar: selectedCar,
              showModal: _showModal,
            );
            break;
          case 3:
            child = SelectFuel(
              updateSelectedFuel: _updateSelectedFuel,
              selectedFuel: selectedFuel,
              showModal: _showModal,
            );
            break;
          case 4:
            child = SelectBorrowDate(
              updateDate: _updateBorrowingDate,
              showModal: _showModal,
            );
            break;
          case 5:
            child = SelectReturnDate(
              updateDate: _updateReturnDate,
              showModal: _showModal,
            );
            break;
          default:
            child = Container();
        }

        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Header
              const Header(title: '차량 등록'),
              // Header와 Footer 사이 공간
              Expanded(
                // 공간 전체 Padding
                child: SafeArea(
                  child: SingleChildScrollView(
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
                              InkWell(
                                  onTap: () {
                                    _showModal(context, 1);
                                  },
                                  child: registerLine(
                                    category: '제조사',
                                    content:
                                        selectedMaker['title'] ?? '제조사를 선택해주세요',
                                    isLastLine: false,
                                    isSelected: selectedMaker['id'] != null,
                                    isInput: false,
                                    isError: false,
                                  )),
                              InkWell(
                                  onTap: selectedMaker['id'] == null
                                      ? () {}
                                      : () {
                                          _showModal(context, 2);
                                        },
                                  child: registerLine(
                                    category: '차종',
                                    content: selectedMaker['id'] == null
                                        ? ''
                                        : selectedCar['title'] ?? '차종을 선택해주세요',
                                    isLastLine: false,
                                    isSelected: selectedCar['id'] != null,
                                    isInput: false,
                                    isError: false,
                                  )),
                              InkWell(
                                  onTap: () {
                                    _showModal(context, 3);
                                  },
                                  child: registerLine(
                                    category: '연료 종류',
                                    content: selectedFuel['title'] ??
                                        '연료 종류를 선택해주세요',
                                    isLastLine: false,
                                    isSelected: selectedFuel['id'] != null,
                                    isInput: false,
                                    isError: false,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const RegisterTitle(title: '대여 정보'),
                          RegisterList(
                            lineList: [
                              InkWell(
                                  onTap: () {
                                    _showModal(context, 4);
                                  },
                                  child: registerLine(
                                    category: '대여 일자',
                                    content: DateFormat('yyyy년 MM월 dd일')
                                        .format(_borrowingDate),
                                    isLastLine: false,
                                    isSelected: true,
                                    isInput: false,
                                    isError: false,
                                  )),
                              InkWell(
                                  onTap: () {
                                    _showModal(context, 5);
                                  },
                                  child: registerLine(
                                    category: '반납 일자',
                                    content: DateFormat('yyyy년 MM월 dd일')
                                        .format(_returnDate),
                                    isLastLine: false,
                                    isSelected: true,
                                    isInput: false,
                                    isError: !_isValidatedDate,
                                  )),
                              registerLine(
                                category: '렌트카 업체',
                                isLastLine: false,
                                isSelected: false,
                                isInput: true,
                                updateInput: _updateInputRentalCompany,
                                placeholder: '렌트카 업체를 입력해주세요.',
                                focusNode: _rentalCompanyFocusNode,
                                onSubmitted: () {
                                  _carNumberFocusNode.requestFocus();
                                },
                                isError: false,
                              ),
                              registerLine(
                                category: '차량번호',
                                isLastLine: false,
                                isSelected: false,
                                isInput: true,
                                updateInput: _updateInputCarNumber,
                                placeholder: '차량번호를 입력해주세요.',
                                focusNode: _carNumberFocusNode,
                                isError: false,
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
                                  onPressed: _allRegistered
                                      ? () {
                                          postCarInfo(
                                              success:
                                                  (dynamic response) async {
                                                await storage.write(
                                                    key: "carId",
                                                    value: response.toString());
                                                Navigator.pushNamed(
                                                    context, '/home');
                                              },
                                              fail: (error) {
                                                print('차량 리스트 호출 오류: $error');
                                                // Navigator
                                                //     .pushNamedAndRemoveUntil(
                                                //   context,
                                                //   '/error',
                                                //   arguments: {
                                                //     'errorText': error,
                                                //   },
                                                //   ModalRoute.withName('/home'),
                                                // );
                                              },
                                              body: _buildCarInfoBody());
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
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
                ),
              ),
              if (!isKeyboardVisible(context)) const Footer()
            ],
          )),
    );
  }
}
