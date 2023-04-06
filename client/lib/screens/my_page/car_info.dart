import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../services/my_page_api.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/register/register_line.dart';
import '../../widgets/register/register_list.dart';
import '../../widgets/register/register_title.dart';
import './car_modify.dart';

class CarInfo extends StatefulWidget {
  const CarInfo({Key? key}) : super(key: key);

  @override
  State<CarInfo> createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
  static const storage = FlutterSecureStorage();
  var rentedCar;

  @override
  void initState() {
    getRentedCarInfo(
      success: (dynamic response) {
        setState(() {
          rentedCar = response;
        });
      },
      fail: (error) {
        print('대여중인 차량 호출 오류: $error');
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const Header(title: '차량 정보 조회'),
          // Header와 Footer 사이 공간
          Expanded(
            // 공간 전체 Padding
            child: rentedCar == null
                ? const Center(child: Text("현재 대여중인 차량이 없습니다"))
                : SafeArea(
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
                                registerLine(
                                  category: '제조사',
                                  content: rentedCar['carManufacturer'] ?? "",
                                  isLastLine: false,
                                  isSelected: false,
                                  isInput: false,
                                  isError: false,
                                ),
                                registerLine(
                                  category: '차종',
                                  content: rentedCar['carModel'] ?? "",
                                  isLastLine: false,
                                  isSelected: false,
                                  isInput: false,
                                  isError: false,
                                ),
                                registerLine(
                                  category: '연료 종류',
                                  content:
                                      rentedCar['carFuel'] ?? '연료 종류를 선택해주세요',
                                  isLastLine: false,
                                  isSelected: false,
                                  isInput: false,
                                  isError: false,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const RegisterTitle(title: '대여 정보'),
                            RegisterList(
                              lineList: [
                                registerLine(
                                  category: '대여 일자',
                                  content: DateFormat('yyyy년 MM월 dd일').format(
                                          DateTime.parse(
                                              rentedCar['rentalDate'])) ??
                                      "",
                                  isLastLine: false,
                                  isSelected: true,
                                  isInput: false,
                                  isError: false,
                                ),
                                registerLine(
                                  category: '반납 일자',
                                  content: DateFormat('yyyy년 MM월 dd일').format(
                                          DateTime.parse(
                                              rentedCar['returnDate'])) ??
                                      "",
                                  isLastLine: false,
                                  isSelected: true,
                                  isInput: false,
                                  isError: false,
                                ),
                                registerLine(
                                  category: '렌트카 업체',
                                  content: rentedCar['rentalCompany'] ?? "",
                                  isLastLine: false,
                                  isSelected: false,
                                  isInput: false,
                                  isError: false,
                                ),
                                registerLine(
                                  category: '차량번호',
                                  isLastLine: false,
                                  isSelected: false,
                                  isInput: false,
                                  content: rentedCar['carNumber'] ?? "",
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CarModify(
                                            carId: rentedCar['carId'],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    child: const SizedBox(
                                      width: 70,
                                      child: Text(
                                        '수정하기',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      deleteCarInfo(
                                          success: (dynamic response) async {
                                            await storage.write(
                                                key: "carId", value: "0");
                                            await storage.write(
                                                key: "carVideoState",
                                                value: "0");
                                          },
                                          fail: (error) {
                                            print('차량 삭제 호출 오류: $error');
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/error',
                                              arguments: {
                                                'errorText': error,
                                              },
                                              ModalRoute.withName('/home'),
                                            );
                                          },
                                          carId: rentedCar['carId']);
                                      Navigator.pushNamed(context, '/my-page');
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    child: const SizedBox(
                                      width: 70,
                                      child: Text(
                                        '삭제하기',
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
          const Footer()
        ],
      ),
    );
  }
}
