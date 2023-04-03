import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:client/widgets/main_page/Main_Page_Body.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  dynamic userProfileImg = '';
  dynamic userCarId = '0';
  dynamic firstVideoInfo = true;
  dynamic firstCheckDamage = true;
  dynamic currentCarVideo = '0';

  // dynamic userName = '';
  // dynamic userEmail = '';

  @override
  void initState() {
    super.initState();
    // checkUserState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  checkUserState() async {
    var name = await storage.read(key: 'nickName');
    var img = await storage.read(key: 'picture ');
    var carId = await storage.read(key: 'carId');
    var videoinfo = await storage.read(key: 'firstVideoInfo');
    var checkDamage = await storage.read(key: 'firstCheckDamage');
    var carVideoState = await storage.read(key: 'carVideoState');
    setState(() {
      userName = name;
      userProfileImg = img;
      userCarId = carId;
      firstVideoInfo = videoinfo;
      firstCheckDamage = checkDamage;
      currentCarVideo = carVideoState;
    });
    if (userName == null) {
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: userCarId == '0'
                ? MainPageBody(
                    imgRoute: 'lib/assets/images/empty_garage.svg',
                    imageDisabled: true,
                    mainContainter: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '대여중인 차가 없습니다',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '자동차를 등록해주세요',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : MainPageBody(
                    imgRoute: 'lib/assets/images/car_garage.svg',
                    imageDisabled: false,
                    mainContainter: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/detail');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: const Text('차량 상세 페이지'))
                      ],
                    ),
                  ),
          ),
          const Footer()
        ],
      ),
    );
  }
}
