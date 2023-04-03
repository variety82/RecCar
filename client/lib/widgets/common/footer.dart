import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../screens/map_screen/map_screen.dart';
import '../../screens/my_page/my_page.dart';
import '../../main.dart';
import 'package:client/widgets/common/home_FAB.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  void home() {}

  static final storage = FlutterSecureStorage();
  int? currentCarId;
  int? currentCarVideo;

  Future<void> setCurrentCarId() async {
    final carId = await storage.read(key: 'carId');
    setState(() {
      currentCarId = int.parse(carId!);
    });
  }

  Future<void> setCurrentCarVideo() async {
    final carVideoState = await storage.read(key: 'carVideoState');
    setState(() {
      if (carVideoState == '0') {
        setState(() {
          currentCarVideo = 0;
        });
      } else if (carVideoState == '1') {
        setState(() {
          currentCarVideo = 1;
        });
      } else {
        setState(() {
          currentCarVideo = 2;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setCurrentCarId();
    setCurrentCarVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/home') {
                Navigator.pushNamed(context, '/home');
              }
            },
            child: const Icon(
              Icons.home_outlined,
              color: Color(0xFFABABAB),
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/station') {
                Navigator.pushNamed(context, '/station');
              }
            },
            child: const Icon(
              Icons.local_gas_station_outlined,
              color: Color(0xFFABABAB),
              size: 30,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: homeFABMenu(),
          // ),
          TextButton(
            onPressed: () {
              if (currentCarVideo == 2 || currentCarId == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                  SnackBar(
                    content: Center(
                      child: Text(
                        "현재 영상을 찍을 수 없습니다",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                    // action: SnackBarAction(
                    //   label: '닫기',
                    //   textColor: Colors.white,
                    //   onPressed: () => {},
                    // ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                );
              } else {
                if (ModalRoute.of(context)?.settings.name !=
                    '/before-recording') {
                  Navigator.pushNamed(context, '/before-recording');
                }
              }
            },
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Transform.scale(
                scale: 1.5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0XFFE0426F),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/calendar') {
                Navigator.pushNamed(context, '/calendar');
              }
            },
            child: const Icon(
              Icons.event_note_outlined,
              color: Color(0XFFABABAB),
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/my-page') {
                Navigator.pushNamed(context, '/my-page');
              }
            },
            child: const Icon(
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
