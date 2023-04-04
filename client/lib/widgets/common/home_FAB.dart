import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:client/widgets/register/register_line.dart';
import 'package:client/widgets/register/register_title.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter_modal.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter.dart';

class homeFABMenu extends StatefulWidget {
  final int? currentCarId;
  final int? currentCarVideo;

  const homeFABMenu({
    super.key,
    required this.currentCarId,
    required this.currentCarVideo,
  });

  @override
  _homeFABMenuState createState() => _homeFABMenuState();
}

class _homeFABMenuState extends State<homeFABMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _translateAnimation;

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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _rotateAnimation =
        Tween<double>(begin: 0.0, end: 0.5).animate(_animationController);
    _translateAnimation =
        Tween<double>(begin: 0.0, end: 80.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      buttonSize: const Size(64, 64),
      overlayOpacity: 0.0,
      onPress: () {},
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          size: 30,
          // color: Theme.of(context).primaryColorLight,
        ),
      ),
      // icon: IconData(Icons.camera_alt_outlined, size: 24),
      activeIcon: Icons.close,
      visible: true,
      curve: Curves.bounceIn,
      direction: SpeedDialDirection.up,
      backgroundColor: Color(0xFFE0426F),
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.videocam_outlined,
            color: Colors.white,
          ),
          label: "영상 촬영",
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 13.0,
          ),
          backgroundColor: Color(0xFFE0426F),
          labelBackgroundColor: Color(0xFFE0426F),
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.video_collection_outlined,
            color: Colors.white,
          ),
          label: "영상 선택",
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 13.0,
          ),
          backgroundColor: Color(0xFFE0426F),
          labelBackgroundColor: Color(0xFFE0426F),
          onTap: () {},
        ),
      ],
    );
  }
}
