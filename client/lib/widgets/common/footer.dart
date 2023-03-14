import 'package:flutter/material.dart';
import '../../screens/gas_station_search_page/gas_station_search.dart';
import '../../screens/my_page/my_page.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  void home() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.home_outlined,
              color: Color(0xFFABABAB),
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NaverMapTest()),
              );
            },
            child: Icon(
              Icons.local_gas_station_outlined,
              color: Color(0xFFABABAB),
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Transform.translate(
              offset: Offset(0, -10),
              child: Transform.scale(
                scale: 1.3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0XFFE0426F),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.event_note_outlined,
              color: Color(0XFFABABAB),
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyPage()),
              );
            },
            child: Icon(
              Icons.person_outline,
              color: Color(0XFFABABAB),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
