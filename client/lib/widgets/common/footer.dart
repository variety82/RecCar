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

  void showConfirmationDialog(BuildContext context, String title,
      String content, String yes_text, String no_text,
      {String? route, dynamic data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                yes_text,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // Yes 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(
                no_text,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // No 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        if (route != null) {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        } else {}
      } else if (value == false) {
        // No 버튼을 눌렀을 때 수행할 작업
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
            child: Icon(
              ModalRoute.of(context)?.settings.name != '/home'
                  ? Icons.home_outlined
                  : Icons.home,
              color: ModalRoute.of(context)?.settings.name != '/home'
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).secondaryHeaderColor,
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/station') {
                Navigator.pushNamed(context, '/station');
              }
            },
            child: Icon(
              ModalRoute.of(context)?.settings.name != '/station'
                  ? Icons.map_outlined
                  : Icons.map,
              color: ModalRoute.of(context)?.settings.name != '/station'
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).secondaryHeaderColor,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
            ),
            child: homeFABMenu(
              currentCarId: currentCarId,
              currentCarVideo: currentCarVideo,
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/calendar') {
                Navigator.pushNamed(context, '/calendar');
              }
            },
            child: Icon(
              ModalRoute.of(context)?.settings.name != '/calendar'
                  ? Icons.event_note_outlined
                  : Icons.event_note,
              color: ModalRoute.of(context)?.settings.name != '/calendar'
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).secondaryHeaderColor,
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/my-page') {
                Navigator.pushNamed(context, '/my-page');
              }
            },
            child: Icon(
              ModalRoute.of(context)?.settings.name != '/my-page'
                  ? Icons.person_outline
                  : Icons.person,
              color: ModalRoute.of(context)?.settings.name != '/my-page'
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).secondaryHeaderColor,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
