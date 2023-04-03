import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:client/widgets/main_page/main_page_body.dart';

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
      // userCarId = carId;
      userCarId = '0';
      firstVideoInfo = videoinfo;
      firstCheckDamage = checkDamage;
      // currentCarVideo = carVideoState;
      currentCarVideo = '0';
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF999999).withOpacity(0.5),
                                        spreadRadius: 0.3,
                                        blurRadius: 6,
                                      )
                                    ]
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Column(
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF999999).withOpacity(0.5),
                                      spreadRadius: 0.3,
                                      blurRadius: 6,
                                    )
                                  ]
                              ),
                              width: double.infinity,
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
                        if (currentCarVideo == '0')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF999999).withOpacity(0.5),
                                          spreadRadius: 0.3,
                                          blurRadius: 6,
                                        )
                                      ]
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '대여하기 전, 차량의 손상 상태를 파악하기 위해 영상 촬영을 진행해주세요.',
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (currentCarVideo == '1')
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/detail');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).primaryColor),
                            child: const Text('촬영하기'),
                          ),
                        if (currentCarVideo == '2')
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/detail');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).primaryColor),
                            child: const Text('어떤 작업'),
                          ),
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
