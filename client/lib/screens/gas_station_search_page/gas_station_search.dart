import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart' as naver;
import '../../widgets/common/footer.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:http/http.dart';
import 'dart:convert';
// import 'package:geolocator/geolocator.dart';

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  // naver.MapType _mapType = naver.MapType.Basic;
  late naver.NaverMapController _controller;
  List<Map<String, dynamic>> result =
  List<Map<String, dynamic>>.filled(100, {});
  bool beforeSearch = true;
  List<naver.Marker> marker = List<naver.Marker>.filled(
      1, naver.Marker(markerId: "marker", position: naver.LatLng(0, 0)));

  Widget _previewWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          Divider(
            color: Color(0xFF6A6A6A),
            indent: 160,
            endIndent: 160,
            thickness: 2,
            height: 30,
          ),
          Container(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _expandedWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Divider(
            color: Color(0xFF6A6A6A),
            indent: 160,
            endIndent: 160,
            thickness: 2,
            height: 30,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (result[0].isEmpty)
                      Text(
                        "검색 결과가 없습니다",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (!result[0].isEmpty)
                      for (int i = 0; i < 100; i++)
                        if (result[i] != {})
                          TextButton(
                            onPressed: () => move(i),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                              ),
                              padding: EdgeInsetsDirectional.only(
                                bottom: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        "${result[i]['name']}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          // height: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        "${result[i]['upperAddrName']} ${result[i]['middleAddrName']} ${result[i]['lowerAddrName']}",
                                        style: TextStyle(
                                          // color: Colors.black,
                                          // decoration: TextDecoration.none,
                                          // fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          // height: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _backgroundWidget() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Expanded(
                child: Container(
                  child: naver.NaverMap(
                    onMapCreated: onMapCreated,
                    markers: marker,
                    // mapType: _mapType,
                    // onMapTap: onMapTap,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  width: 300,
                  height: 42,
                  child: Card(
                    elevation: 0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: '검색어',
                      ),
                      onSubmitted: (value) => search(value),
                    ),
                  ),
                ),
                top: 40,
                left: 50,
                right: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              if (beforeSearch)
                DraggableBottomSheet(
                  previewWidget: _previewWidget(),
                  backgroundWidget: _backgroundWidget(),
                  expandedWidget: _expandedWidget(),
                  onDragging: (pos) {},
                  maxExtent: 400,
                ),
              if (!beforeSearch)
                DraggableBottomSheet(
                  previewWidget: _expandedWidget(),
                  backgroundWidget: _backgroundWidget(),
                  expandedWidget: _expandedWidget(),
                  onDragging: (pos) {},
                  maxExtent: 400,
                  collapsed: false,
                ),
            ],
          ),
        ),
        Footer(),
      ],
    );
  }

  void onMapCreated(naver.NaverMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  // void onMapTap(naver.LatLng latLng) {
  //   search("주유소");
  //   print("id: " + result[0]['id']);
  // }

  void move(int i) {
    var lat = double.parse(result[i]["frontLat"]);
    var lng = double.parse(result[i]["frontLon"]);
    var latLng = naver.LatLng(lat, lng);
    _controller.moveCamera(naver.CameraUpdate.toCameraPosition(
        naver.CameraPosition(target: latLng)));
    setState(() {
      marker[0] = naver.Marker(
        markerId: "${result[i]["name"]}",
        position: latLng,
        infoWindow: result[i]["telNo"]==""?"${result[i]["name"]}\n전화번호없음":"${result[i]["name"]}\n${result[i]["telNo"]}",
      );
    });


    // if(result[i]["name"].toString().contains("주유소")) { // 주유소의 경우 유가 정보 출력해주려했는데
    //   getGasInfo(result[i]["id"]);
    // }
  }

  // Future<void> getGasInfo(id) async { // 유가 정보 불러오는 API
  //   Map<String, String> headers = {
  //     "appkey": "l7xxe210feb29ba24deda6a06b0d0e88366a",
  //   };
  //   Response response = await get(
  //     Uri.parse(
  //         "https://apis.openapi.sk.com/tmap/oilinfo/poiDetailOil?version=1&poiId=${id}"),
  //     headers: headers,
  //   );
  //   var jsonData = response.body;
  //   var ret = jsonDecode(jsonData);
  //   print(ret);
  //   // 유가 정보 API 이용은 1일 1회만 무료래용......
  // }

  Future<void> search(keyword) async {
    Map<String, String> headers = {
      "appkey": "l7xxe210feb29ba24deda6a06b0d0e88366a",
    };
    Response response = await get(
      Uri.parse(
          "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result&searchKeyword=${keyword}&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=100"),
      headers: headers,
    );
    var jsonData = response.body;
    var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];

    setState(() {
      for (int i = 0; i < ret.length; i++) {
        result[i] = ret[i];
      }
    });
  }
}
