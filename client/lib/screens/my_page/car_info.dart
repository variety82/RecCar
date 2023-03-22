import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import '../register/car_register_main.dart';

class CarInfo extends StatefulWidget {
  const CarInfo({Key? key}) : super(key: key);

  @override
  State<CarInfo> createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
  void editCarInfo() {}

  void editRentInfo() {}

  @override
  Widget build(BuildContext context) {
    return CarRegister();
    // return Container(
    //   color: Colors.white,
    //   child: Column(
    //     children: [
    //       Header(
    //         title: '차량 정보 조회',
    //       ),
    //       SizedBox(
    //         height: 40,
    //       ),
    //       Expanded(
    //         // 공간 전체 Padding
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(
    //             vertical: 8,
    //             horizontal: 14,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               // 등록페이지의 제목 Class화
    //               const RegisterTitle(title: '차량 정보'),
    //               // 등록 페이지 목록 형식 Class화
    //               RegisterList(
    //                 // 목록의 각각 줄들이 들어가는 paramater
    //                 lineList: [
    //                   // 모달 오픈하는 Custom Class
    //                   ModalNavigator(
    //                     // SelectMaker 위젯을 보여줌
    //                     showedWidget: SelectMaker(
    //                       updateSelectedMaker: _updateSelectedMaker,
    //                     ),
    //                     // 클릭하는 영역
    //                     child: registerLine(
    //                       category: '제조사',
    //                       content: selectedMaker['title'],
    //                       isLastLine: false,
    //                     ),
    //                   ),
    //                   ModalNavigator(
    //                     showedWidget: SelectItem(
    //                       updateSelectedItem: _updateSelectedCar,
    //                     ),
    //                     child: registerLine(
    //                       category: '차종',
    //                       content: selectedCar['title'],
    //                       isLastLine: false,
    //                     ),
    //                   ),
    //                   const registerLine(
    //                     category: '연료 종류',
    //                     content: '가솔린',
    //                     isLastLine: true,
    //                   ),
    //                 ],
    //               ),
    //               const RegisterTitle(title: '대여 정보'),
    //               RegisterList(
    //                 lineList: [
    //                   ModalNavigator(
    //                     showedWidget: SelectBorrowDate(
    //                       updateSelectedDate: _updateSelectedDate,
    //                     ),
    //                     child: registerLine(
    //                       category: '대여 일자',
    //                       content: DateFormat('yyyy년 MM월 dd일')
    //                           .format(_borrowingDate),
    //                       isLastLine: false,
    //                     ),
    //                   ),
    //                   const registerLine(
    //                     category: '반납 일자',
    //                     content: '2023년 10월 25일',
    //                     isLastLine: false,
    //                   ),
    //                   const registerLine(
    //                     category: '렌트카 업체',
    //                     content: 'SSAFY',
    //                     isLastLine: false,
    //                   ),
    //                   const registerLine(
    //                     category: '차량 번호',
    //                     content: '00허 2102',
    //                     isLastLine: true,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       // Expanded(
    //       //   child: Column(
    //       //     mainAxisAlignment: MainAxisAlignment.center,
    //       //     children: [
    //       //       // 차량 정보
    //       //       Container(
    //       //         child: Column(
    //       //           children: [
    //       //             Container(
    //       //               padding: EdgeInsets.symmetric(horizontal: 20),
    //       //               child: Row(
    //       //                 crossAxisAlignment: CrossAxisAlignment.center,
    //       //                 children: [
    //       //                   Text(
    //       //                     "차량 정보",
    //       //                     style: TextStyle(
    //       //                       fontSize: 15,
    //       //                       color: Colors.black,
    //       //                       decoration: TextDecoration.none,
    //       //                     ),
    //       //                   ),
    //       //                   Card(
    //       //                       elevation: 0,
    //       //                       child: IconButton(
    //       //                           onPressed: editCarInfo,
    //       //                           icon: Icon(
    //       //                             Icons.edit,
    //       //                             size: 20,
    //       //                           ))),
    //       //                   // TextButton(
    //       //                   //   onPressed: editCarInfo,
    //       //                   // child: Icon(Icons.edit, color: Theme.of(context).secondaryHeaderColor),
    //       //                   // child: Container(
    //       //                   //   padding: EdgeInsets.symmetric(
    //       //                   //       horizontal: 7, vertical: 2),
    //       //                   //   decoration: BoxDecoration(
    //       //                   //     color: Color(0xFFE0426F),
    //       //                   //     borderRadius: BorderRadius.circular(8),
    //       //                   //   ),
    //       //                   //   child: Row(
    //       //                   //     children: [
    //       //                   //       Icon(Icons.edit, color: Colors.white, size: 15,),
    //       //                   //       Text(
    //       //                   //         "편집",
    //       //                   //         style: TextStyle(
    //       //                   //           fontSize: 12,
    //       //                   //           color: Colors.white,
    //       //                   //           fontWeight: FontWeight.w600,
    //       //                   //         ),
    //       //                   //       ),
    //       //                   //     ],
    //       //                   //   ),
    //       //                   // ),
    //       //                   // ),
    //       //                 ],
    //       //               ),
    //       //             ),
    //       //             Container(
    //       //               decoration: BoxDecoration(
    //       //                 border: Border.all(
    //       //                   width: 1,
    //       //                   color: Color(0xFFD8D8D8),
    //       //                 ),
    //       //                 borderRadius: BorderRadius.circular(8),
    //       //               ),
    //       //               margin: EdgeInsets.symmetric(
    //       //                 horizontal: 20,
    //       //               ),
    //       //               child: Column(
    //       //                 children: [
    //       //                   CarInfoTableRow(rowName: "제조사", rowInfo: "르노 삼성"),
    //       //                   const Divider(
    //       //                     height: 10,
    //       //                     thickness: 1,
    //       //                     color: Color(0xFFD8D8D8),
    //       //                   ),
    //       //                   CarInfoTableRow(rowName: "차종", rowInfo: "SM5"),
    //       //                   const Divider(
    //       //                     height: 10,
    //       //                     thickness: 1,
    //       //                     color: Color(0xFFD8D8D8),
    //       //                   ),
    //       //                   CarInfoTableRow(rowName: "연료 종류", rowInfo: "경유"),
    //       //                 ],
    //       //               ),
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //       // 수정 완료 버튼 (편집 누르면 활성화)
    //       //       // Container(
    //       //       //   alignment: Alignment.topRight,
    //       //       //   padding: EdgeInsets.symmetric(
    //       //       //     horizontal: 10,
    //       //       //   ),
    //       //       //   child: TextButton(
    //       //       //     onPressed: editRentInfo,
    //       //       //     child: Container(
    //       //       //       padding:
    //       //       //           EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    //       //       //       decoration: BoxDecoration(
    //       //       //         color: Color(0xFFE0426F),
    //       //       //         borderRadius: BorderRadius.circular(8),
    //       //       //       ),
    //       //       //       child: Text(
    //       //       //         "완료",
    //       //       //         style: TextStyle(
    //       //       //           fontSize: 13,
    //       //       //           color: Colors.white,
    //       //       //           fontWeight: FontWeight.w600,
    //       //       //         ),
    //       //       //       ),
    //       //       //     ),
    //       //       //   ),
    //       //       // ),
    //       //       SizedBox(
    //       //         height: 15,
    //       //       ),
    //       //       // 대여 정보
    //       //       Container(
    //       //         child: Column(
    //       //           children: [
    //       //             Container(
    //       //               padding: EdgeInsets.symmetric(horizontal: 20),
    //       //               child: Row(
    //       //                 crossAxisAlignment: CrossAxisAlignment.center,
    //       //                 children: [
    //       //                   Text(
    //       //                     "대여 정보",
    //       //                     style: TextStyle(
    //       //                       fontSize: 15,
    //       //                       color: Colors.black,
    //       //                       decoration: TextDecoration.none,
    //       //                     ),
    //       //                   ),
    //       //                   TextButton(
    //       //                     onPressed: editRentInfo,
    //       //                     child: Container(
    //       //                       padding: EdgeInsets.symmetric(
    //       //                           horizontal: 7, vertical: 2),
    //       //                       decoration: BoxDecoration(
    //       //                         color: Color(0xFFE0426F),
    //       //                         borderRadius: BorderRadius.circular(8),
    //       //                       ),
    //       //                       child: Text(
    //       //                         "편집",
    //       //                         style: TextStyle(
    //       //                           fontSize: 12,
    //       //                           color: Colors.white,
    //       //                           fontWeight: FontWeight.w600,
    //       //                         ),
    //       //                       ),
    //       //                     ),
    //       //                   ),
    //       //                 ],
    //       //               ),
    //       //             ),
    //       //             Container(
    //       //               decoration: BoxDecoration(
    //       //                 border: Border.all(
    //       //                   width: 1,
    //       //                   color: Color(0xFFD8D8D8),
    //       //                 ),
    //       //                 borderRadius: BorderRadius.circular(8),
    //       //               ),
    //       //               margin: EdgeInsets.symmetric(
    //       //                 horizontal: 20,
    //       //               ),
    //       //               child: Column(
    //       //                 children: [
    //       //                   CarInfoTableRow(
    //       //                       rowName: "대여 일자", rowInfo: "2023.03.09 10:00"),
    //       //                   const Divider(
    //       //                     height: 10,
    //       //                     thickness: 1,
    //       //                     color: Color(0xFFD8D8D8),
    //       //                   ),
    //       //                   CarInfoTableRow(
    //       //                       rowName: "반납 일자", rowInfo: "2022.03.10 13:00"),
    //       //                   const Divider(
    //       //                     height: 10,
    //       //                     thickness: 1,
    //       //                     color: Color(0xFFD8D8D8),
    //       //                   ),
    //       //                   CarInfoTableRow(rowName: "렌트카 업체", rowInfo: "그린카"),
    //       //                   const Divider(
    //       //                     height: 10,
    //       //                     thickness: 1,
    //       //                     color: Color(0xFFD8D8D8),
    //       //                   ),
    //       //                   CarInfoTableRow(
    //       //                       rowName: "차량 번호", rowInfo: "38모 6715"),
    //       //                 ],
    //       //               ),
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //       // 수정 완료 버튼 (편집 누르면 활성화)
    //       //       Container(
    //       //         alignment: Alignment.topRight,
    //       //         padding: EdgeInsets.symmetric(
    //       //           horizontal: 10,
    //       //         ),
    //       //         child: TextButton(
    //       //           onPressed: editRentInfo,
    //       //           child: Container(
    //       //             padding:
    //       //                 EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    //       //             decoration: BoxDecoration(
    //       //               color: Color(0xFFE0426F),
    //       //               borderRadius: BorderRadius.circular(8),
    //       //             ),
    //       //             child: Text(
    //       //               "수정 완료",
    //       //               style: TextStyle(
    //       //                 fontSize: 13,
    //       //                 color: Colors.white,
    //       //                 fontWeight: FontWeight.w600,
    //       //               ),
    //       //             ),
    //       //           ),
    //       //         ),
    //       //       ),
    //       //     ],
    //       //   ),
    //       // ),
    //       Footer(),
    //     ],
    //   ),
    // );
  }
}
