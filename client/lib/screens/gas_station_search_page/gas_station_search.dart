import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart' as naver;
import '../../widgets/common/footer.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  naver.MapType _mapType = naver.MapType.Basic;
  naver.CameraPosition _cameraPosition =
      naver.CameraPosition(target: naver.LatLng(37.2, 23));
  late naver.NaverMapController _controller;
  List<Map<String, dynamic>> result =
      List<Map<String, dynamic>>.filled(100, {});
  // late Geolocator _geolocator;
  // late Position _position;

  // final keywordController = TextEditingController();

  Widget _previewWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
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
          Container(
              // width: 40,
              // height: 6,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _expandedWidget() {
    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          const Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white),
          // const SizedBox(height: 8),
          const Text(
            "검색 결과",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: 800,
                child: Column(
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
                            child: Text(
                              "${result[i]['name']}",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 3,
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
                    mapType: _mapType,
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
                            borderRadius: BorderRadius.circular(30)),
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
              DraggableBottomSheet(
                previewWidget: _previewWidget(),
                backgroundWidget: _backgroundWidget(),
                expandedWidget: _expandedWidget(),
                onDragging: (pos) {},
                maxExtent: 400,
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
  //
  // void onMapTap(naver.LatLng latLng) {
  //   _geolocator = Geolocator();
  // }

  void move(int i) {
    var lat = double.parse(result[i]["frontLat"]);
    var lng = double.parse(result[i]["frontLon"]);
    var latLng = naver.LatLng(lat, lng);
    _controller.moveCamera(naver.CameraUpdate.toCameraPosition(
        naver.CameraPosition(target: latLng)));
    naver.Marker(markerId: 'marker1', position: latLng);
  }



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
    // print(jsonData['searchPoiInfo']);
    var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];

    setState(() {
      for (int i = 0; i < ret.length; i++) {
        result[i] = ret[i];
      }
    });
  }
}
