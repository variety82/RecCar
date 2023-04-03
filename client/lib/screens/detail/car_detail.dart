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

  // Map<String, int> countDamageParts(List<dynamic> detectionInfos) {
  //   int frontDamageCount = 0;
  //   int sideDamageCount = 0;
  //   int backDamageCount = 0;
  //   int wheelDamageCount = 0;
  //
  //   for (var detection in detectionInfos) {
  //     dynamic part = detection['part'];
  //     int breakage = detection['breakage'];
  //     int crushed = detection['crushed'];
  //     int separated = detection['separated'];
  //     int scratch = detection['scratch'];
  //     int damageCount = breakage + crushed + separated + scratch;
  //
  //     switch (part) {
  //       case Part.front:
  //         frontDamageCount += damageCount;
  //         break;
  //       case Part.side:
  //         sideDamageCount += damageCount;
  //         break;
  //       case Part.back:
  //         backDamageCount += damageCount;
  //         break;
  //       case Part.wheel:
  //         wheelDamageCount += damageCount;
  //         break;
  //     };
  //   };
  //
  //   return {
  //     'frontDamageCount' : frontDamageCount,
  //     'sideDamageCount' : sideDamageCount,
  //     'backDamageCount' : backDamageCount,
  //     'wheelDamageCount' : wheelDamageCount,
  //   };
  // }

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
                  detectionInfos: _detectionInfo?['initialDetectionInfos'] ?? {},
                ),
                partDetail(
                  detectionInfos: _detectionInfo?['latterDetectionInfos'] ?? {},
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}


