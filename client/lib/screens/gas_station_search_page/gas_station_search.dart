import 'dart:async';

import 'package:flutter/material.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/footer.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  final keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Expanded(
                child: Container(
                  child: NaverMap(
                    onMapCreated: onMapCreated,
                    mapType: _mapType,
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
                      controller: keywordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        labelText: '검색어',
                      ),
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
        Footer(),
      ],
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void move(NaverMapController controller) {
    // controller.moveCamera(CameraUpdate.toCameraPosition(CameraPosition(target: _latlng)));
  }
}
