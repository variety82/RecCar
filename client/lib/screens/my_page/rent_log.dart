import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import '../../widgets/my_page/rent_log_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/services/my_page_api.dart';

class RentLog extends StatefulWidget {
  const RentLog({Key? key}) : super(key: key);

  @override
  State<RentLog> createState() => _RentLogState();
}

class _RentLogState extends State<RentLog> {
  static final storage = FlutterSecureStorage();
  // dynamic userId = '';
  dynamic userName = '';
  // dynamic userProfileImg = '';
  dynamic simpleRentInfo = [];

  @override
  void initState() {
    super.initState();
    getSimpleRentInfo(
      success: (dynamic response) {
        setState(() {
          simpleRentInfo = response;
        });
        // print(response[0]);
      },
      fail: (error) {
        print('렌트 내역 호출 오류: $error');
      },
    );
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkUserState();
    // });
  }

  // checkUserState() async {
  //   var id = await storage.read(key: 'id');
  //   var name = await storage.read(key: 'name');
  //   var email = await storage.read(key: 'email');
  //   var img = await storage.read(key: 'profileImg');
  //   setState(() {
  //     userId = id;
  //     userName = name;
  //     userEmail = email;
  //     userProfileImg = img;
  //   });
  //   if (userId == null) {
  //     Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 80,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 렌트 내역 개수 출력
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '총 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '${simpleRentInfo.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: '건의 렌트 내역',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 간격
          SizedBox(
            height: 20,
          ),
          Expanded(
            // 렌트 내역은 스크롤이 가능하게
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 렌트 내역을 리스트로 출력
                  for (var info in simpleRentInfo)
                    // RentLogCard 위젯에 데이터를 넘겨줌
                    RentLogCard(
                      startDate: info['rentalDate']
                          .toString()
                          .substring(0, 10),
                      endDate: info['returnDate']
                          .toString()
                          .substring(0, 10),
                      company: info['rentalCompany'],
                      damage: info['damage'] < 0 ? 0 : info['damage'],
                      carId: info['carId'],
                    ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
