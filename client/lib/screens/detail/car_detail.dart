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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCarInfo();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar:
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 35,
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
          const Footer()
        ],
      )
    );
  }
}


