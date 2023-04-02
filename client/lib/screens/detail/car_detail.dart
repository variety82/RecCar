import 'package:client/services/detail_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'package:client/widgets/detail/part_detail.dart';

enum Part { front, side, back, wheel }

class CarDetail extends StatefulWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> with SingleTickerProviderStateMixin {

  FlutterSecureStorage storage = const FlutterSecureStorage();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCarInfo();
  }

  Map<String, dynamic>? _detectionInfo;

  Map<String, int> countDamageParts(List<dynamic> detectionInfos) {
    int frontDamageCount = 0;
    int sideDamageCount = 0;
    int backDamageCount = 0;
    int wheelDamageCount = 0;

    for (var detection in detectionInfos) {
      dynamic part = detection['part'];
      int breakage = detection['breakage'];
      int crushed = detection['crushed'];
      int separated = detection['separated'];
      int scratch = detection['scratch'];
      int damageCount = breakage + crushed + separated + scratch;

      switch (part) {
        case Part.front:
          frontDamageCount += damageCount;
          break;
        case Part.side:
          sideDamageCount += damageCount;
          break;
        case Part.back:
          backDamageCount += damageCount;
          break;
        case Part.wheel:
          wheelDamageCount += damageCount;
          break;
      };
    };

    return {
      'frontDamageCount' : frontDamageCount,
      'sideDamageCount' : sideDamageCount,
      'backDamageCount' : backDamageCount,
      'wheelDamageCount' : wheelDamageCount,
    };
  }

  int evaluateDamageLevel(int damageCount) {
    if (damageCount <= 4) {
      return 0;
    } else if (damageCount <= 8) {
      return 1;
    } else if (damageCount <= 12) {
      return 2;
    } else if (damageCount <= 16) {
      return 3;
    } else {
      return 4;
    }
  }

  void processDetectionInfos(Map<String, dynamic>? detectionInfo) {
    List<dynamic> initialDetectionInfos = detectionInfo!['initialDetectionInfos'];
    List<dynamic> latterDetectionInfos = detectionInfo['latterDetectionInfos'];

    Map<String, int> initialDamageCount = countDamageParts(initialDetectionInfos);
    Map<String, int> latterDamageCount = countDamageParts(latterDetectionInfos);

    int initialFrontDamageLevel = evaluateDamageLevel(initialDamageCount['front']!);
    int initialSideDamageLevel = evaluateDamageLevel(initialDamageCount['side']!);
    int initialBackDamageLevel = evaluateDamageLevel(initialDamageCount['back']!);
    int initialWheelDamageLevel = evaluateDamageLevel(initialDamageCount['wheel']!);

    int latterFrontDamageLevel = evaluateDamageLevel(latterDamageCount['front']!);
    int latterSideDamageLevel = evaluateDamageLevel(latterDamageCount['side']!);
    int latterBackDamageLevel = evaluateDamageLevel(latterDamageCount['back']!);
    int latterWheelDamageLevel = evaluateDamageLevel(latterDamageCount['wheel']!);

    print(initialDamageCount);
    print(latterDamageCount);
  }

  Future<void> _fetchCarInfo() async {
    var carId = await storage.read(key: 'carId');
    print(carId);
    if (carId != null) {
      getDetectionInfo(
          success: (dynamic response) {
            // print(response);
            setState(() {
              _detectionInfo = response;
              processDetectionInfos(_detectionInfo);
            });
            print(_detectionInfo);
          },
          fail: (error) {
            print('차량 파손 정보 호출 오류 : $error');
          },
          carId: carId
      );
    }
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar:
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 25,
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
              children: [
                partDetail(
                  frontDamageLevel: 0,
                  sideDamageLevel: 0,
                  backDamageLevel: 0,
                  wheelDamageLevel: 0,
                ),
                partDetail(
                  frontDamageLevel: 0,
                  sideDamageLevel: 0,
                  backDamageLevel: 0,
                  wheelDamageLevel: 0,
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}


