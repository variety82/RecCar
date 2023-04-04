import 'package:client/services/detail_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/screens/detail/part_detail.dart';
import 'package:client/widgets/common/footer.dart';

enum Part { front, side, back, wheel }

class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> with SingleTickerProviderStateMixin {

  FlutterSecureStorage storage = const FlutterSecureStorage();

  TabController? _tabController;
  String? currentCarVideo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
    _fetchCarInfo();
  }
  int _previousTabIndex = 0;

  void _handleTabSelection() {
    if (_tabController?.indexIsChanging ?? false) {
      if (_tabController?.index == 1 && currentCarVideo == '1' && _previousTabIndex == 0) {
        _tabController?.animateTo(0);
        _showModal(context);
      }
      _previousTabIndex = _tabController?.index ?? 0;
    }
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              '반납 영상이 등록되지 않았습니다.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                minimumSize: MaterialStateProperty.all(const Size(60,35)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                minimumSize: MaterialStateProperty.all(const Size(60,35)),
              ),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/before-recording');              },
              child: const Text('등록'),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic>? _detectionInfo;

  Future<void> _fetchCarInfo() async {
    getCarInfo(
      success: (dynamic response) {
        setState(() {
          _detectionInfo = response;
        });
      },
      fail: (error) {
        print('차량 파손 정보 호출 오류 : $error');
      }
    );
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    if (args != null) {
      currentCarVideo = args['currentCarVideo'];
    }
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar:
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
          children: [
            SizedBox(
              height: statusBarHeight,
            ),
            PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).secondaryHeaderColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 5,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
                  tabs: const [
                    Tab(
                      text: '대여',
                    ),
                    Tab(
                      text: '반납',
                    ),
                  ]
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: currentCarVideo == '1' ? const NeverScrollableScrollPhysics() : null,
                children: [
                  partDetail(
                    detectionInfos: _detectionInfo?['initialDetectionInfos'] ?? {},
                    frontDamageCount: _detectionInfo?['initialFrontDamageCount'] ?? 0,
                    sideDamageCount: _detectionInfo?['initialSideDamageCount'] ?? 0,
                    backDamageCount: _detectionInfo?['initialBackDamageCount'] ?? 0,
                    wheelDamageCount: _detectionInfo?['initialWheelDamageCount'] ?? 0,
                  ),
                  partDetail(
                    detectionInfos: _detectionInfo?['latterDetectionInfos'] ?? {},
                    frontDamageCount: _detectionInfo?['latterFrontDamageCount'] ?? 0,
                    sideDamageCount: _detectionInfo?['latterSideDamageCount'] ?? 0,
                    backDamageCount: _detectionInfo?['latterBackDamageCount'] ?? 0,
                    wheelDamageCount: _detectionInfo?['latterWheelDamageCount'] ?? 0,
                  ),
                ],
              ),
            ),
            const Footer()
            ],
          ),
          if (currentCarVideo == '2')
            Positioned(
              top: 120,
              right: 20,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      getCarReturn(
                          success: (dynamic response) async {
                            await storage.write(key: "carId", value: '0');
                            await storage.write(key: "carVideoState", value: '0');
                          },
                          fail: (error) {
                            print('차량 반납 요청 오류 : $error');
                          }
                      );
                    },
                    mini: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0), // 원하는 모서리 반경을 설정합니다.
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                        Icons.reply,
                    ),
                  ),
                  Positioned(
                    top: 55,
                    child: Text(
                        '반납하기',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


