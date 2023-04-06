import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/widgets/common/footer.dart';
import 'package:client/widgets/main_page/main_page_body.dart';
import 'package:client/screens/before_recording_confirm_screen/before_recording_confirm_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  dynamic userProfileImg = '';
  String? userCarId;
  dynamic firstVideoInfo = true;
  dynamic firstCheckDamage = true;
  String? currentCarVideo;

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
    var videoInfo = await storage.read(key: 'firstVideoInfo');
    var checkDamage = await storage.read(key: 'firstCheckDamage');
    var carVideoState = await storage.read(key: 'carVideoState');
    setState(() {
      userName = name;
      userProfileImg = img;
      userCarId = carId;
      firstVideoInfo = videoInfo;
      firstCheckDamage = checkDamage;
      currentCarVideo = carVideoState;
    });
    if (userName == null) {
      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
    }
  }

  void _showSelectModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            '영상 등록 방법을 선택해주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                minimumSize: MaterialStateProperty.all(const Size(60, 35)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BeforeRecordingConfirmScreen(videoCase: 'pick'),
                  ),
                );
              },
              child: const Text('기존 영상'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                minimumSize: MaterialStateProperty.all(const Size(60, 35)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BeforeRecordingConfirmScreen(videoCase: 'take'),
                  ),
                );
              },
              child: const Text('신규 촬영'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.white,
      body: userCarId == null || currentCarVideo == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: statusBarHeight + screenHeight * 0.01,
                              left: 20,
                              right: 20,
                              bottom: screenHeight * 0.05,
                            ),
                            child:
                            SvgPicture.asset(
                              'lib/assets/images/logo/reccar_logo_horizontal.svg',
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF999999)
                                                        .withOpacity(0.5),
                                                    spreadRadius: 0.3,
                                                    blurRadius: 6,
                                                  )
                                                ]),
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '대여중인 차가 없습니다',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '자동차를 등록해주세요',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
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
                                                  color: const Color(0xFF999999)
                                                      .withOpacity(0.5),
                                                  spreadRadius: 0.3,
                                                  blurRadius: 6,
                                                )
                                              ]),
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
                                            GestureDetector(
                                              onTap: () {
                                                _showSelectModal(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFF999999)
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0.3,
                                                        blurRadius: 6,
                                                      )
                                                    ]),
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '대여 영상 등록하기',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w700),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '차량 손상 분석을 위해 대여 영상 촬영이 필요합니다',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w400),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_forward_ios)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (currentCarVideo == '1')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detail',
                                                  arguments: {
                                                    'currentCarVideo': currentCarVideo
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFF999999)
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0.3,
                                                        blurRadius: 6,
                                                      )
                                                    ]),
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '대여 영상이 등록되었습니다.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '손상 내역 확인하기',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Theme.of(context)
                                                                        .primaryColor,
                                                                fontWeight:
                                                                    FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_forward_ios)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showSelectModal(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFF999999)
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0.3,
                                                        blurRadius: 6,
                                                      )
                                                    ]),
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '반납 영상 등록',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w700),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '차량 손상 분석을 위해 영상 촬영이 필요합니다',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w400),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_forward_ios)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (currentCarVideo == '2')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detail',
                                                  arguments: {
                                                    'currentCarVideo': currentCarVideo
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xFF999999)
                                                          .withOpacity(0.5),
                                                      spreadRadius: 0.3,
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '반납 영상이 등록되었습니다.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '손상 내역 확인하고 반납하기',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Theme.of(context)
                                                                        .primaryColor,
                                                                fontWeight:
                                                                    FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_forward_ios)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                      const Footer()
                    ],
                  ),
              ),
            ),
          ),
    );
  }
}
