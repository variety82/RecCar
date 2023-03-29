import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart' as naver;
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
  // naver.MapType _mapType = naver.MapType.Basic;
  late naver.NaverMapController _controller;
  late Position _position;
  List<Map<String, dynamic>> result =
      List<Map<String, dynamic>>.filled(2000, {});
  bool beforeSearch = true;
  List<naver.Marker> marker = List<naver.Marker>.filled(
      2001, naver.Marker(markerId: "marker", position: naver.LatLng(0, 0)),
      growable: true);

  // @override
  // void initState() {
  //   searchSocar();
  // }

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

  // 늘렸을 때 보이는 형태
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
                      for (int i = 0; i < result.length; i++)
                        if (!result[i].isEmpty)
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
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        "${result[i]['name']}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          // height: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        "${result[i]['upperAddrName']} ${result[i]['middleAddrName']} ${result[i]['lowerAddrName']} ${result[i]['detailAddrName']}",
                                        style: TextStyle(
                                          color: Color(0xFF8B8B8B),
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
                        labelText: "검색어",
                      ),
                      onSubmitted: (value) => search(value),
                    ),
                  ),
                ),
                top: 40,
                left: 50,
                right: 50,
              ),
              Positioned(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 2.5,
                      ),
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            // fixedSize: MaterialStatePropertyAll(
                            //   Size(80, 6),
                            // ),
                          ),
                          onPressed: () => searchSocar(),
                          child: Text("쏘카존보기",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor))),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 2.5,
                      ),
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.transparent),

                          ),
                          onPressed: () => searchGreencar(),
                          child: Text("그린존보기",
                              style: TextStyle(color: Theme.of(context).secondaryHeaderColor))),
                    ),
                  ],
                ),
                top: 70,
                left: 50,
                right: 50,
              ),
              Positioned(
                child: TextButton(
                  onPressed: getCurrentLocation,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6A6A6A),
                          blurRadius: 1.5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.my_location,
                      color: Color(0xFF6A6A6A),
                      size: 25,
                    ),
                  ),
                ),
                bottom: 70,
                left: 15,
              )
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

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = double.parse(position.latitude.toString());
    var lng = double.parse(position.longitude.toString());
    var latLng = naver.LatLng(lat, lng);
    _controller.moveCamera(naver.CameraUpdate.toCameraPosition(
        naver.CameraPosition(target: latLng)));
  }

  void onMapCreated(naver.NaverMapController controller) {
    setState(() {
      _controller = controller;
    });
    getCurrentLocation();
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
          infoWindow: "${result[i]["name"]}");
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

  Future<void> searchSocar() async {
    Map<String, String> headers = {
      "appkey": "l7xxe210feb29ba24deda6a06b0d0e88366a",
    };
    marker = List<naver.Marker>.filled(
        2001, naver.Marker(markerId: "marker", position: naver.LatLng(0, 0)),
        growable: true);
    for (int i = 1; i <= 20; i++) {
      Response response = await get(
        Uri.parse(
            "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result&searchKeyword=쏘카존&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=100&page=${i}"),
        headers: headers,
      );
      var jsonData = response.body;
      var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];
      setState(() {
        for (int j = 0; j < ret.length; j++) {
          result[100 * (i - 1) + j] = ret[j];
        }
      });
      setState(() {
        for (int j = 0; j < ret.length; j++) {
          var lat = double.parse(ret[j]["frontLat"]);
          var lng = double.parse(ret[j]["frontLon"]);
          var latLng = naver.LatLng(lat, lng);
          marker[100 * (i - 1) + j + 1] = (naver.Marker(
              markerId: "${ret[j]['name']}",
              position: latLng,
              infoWindow: "${ret[j]['name']}"));
        }
      });
    }
    print(marker);
    // Response response = await get(
    //   Uri.parse(
    //       "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result&searchKeyword=쏘카존&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=100&page=20"),
    //   headers: headers,
    // );
    // var jsonData = response.body;
    // var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];
    //
    // setState(() {
    //   for (int i = 0; i < ret.length; i++) {
    //     result[i] = ret[i];
    //   }
    // });
  }

  Future<void> searchGreencar() async {
    Map<String, String> headers = {
      "appkey": "l7xxe210feb29ba24deda6a06b0d0e88366a",
    };
    marker = List<naver.Marker>.filled(
        2001, naver.Marker(markerId: "marker", position: naver.LatLng(0, 0)),
        growable: true);
    for (int i = 1; i <= 20; i++) {
      Response response = await get(
        Uri.parse(
            "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result&searchKeyword=그린카존&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=100&page=${i}"),
        headers: headers,
      );
      var jsonData = response.body;
      var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];
      setState(() {
        for (int j = 0; j < ret.length; j++) {
          result[100 * (i - 1) + j] = ret[j];
        }
      });
      setState(() {
        for (int j = 0; j < ret.length; j++) {
          var lat = double.parse(ret[j]["frontLat"]);
          var lng = double.parse(ret[j]["frontLon"]);
          var latLng = naver.LatLng(lat, lng);
          marker[100 * (i - 1) + j + 1] = (naver.Marker(
              markerId: "${ret[j]['name']}",
              position: latLng,
              infoWindow: "${ret[j]['name']}"));
        }
      });
    }
    // Response response = await get(
    //   Uri.parse(
    //       "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result&searchKeyword=쏘카존&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=100&page=20"),
    //   headers: headers,
    // );
    // var jsonData = response.body;
    // var ret = jsonDecode(jsonData)["searchPoiInfo"]['pois']['poi'];
    //
    // setState(() {
    //   for (int i = 0; i < ret.length; i++) {
    //     result[i] = ret[i];
    //   }
    // });
  }

  void moveToCurLoc() {
    // 현재위치로 이동하는 함수
  }
}
