import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MyFABMenu extends StatefulWidget {
  @override
  _MyFABMenuState createState() => _MyFABMenuState();
}

class _MyFABMenuState extends State<MyFABMenu>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _translateAnimation;

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
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Color(0xFFE0426F),
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.save_as,
            color: Colors.white,
          ),
          label: "저장",
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
            Icons.add_photo_alternate,
            color: Colors.white,
          ),
          label: "손상 추가",
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
            Icons.filter_alt,
            color: Colors.white,
          ),
          label: "필터링 설정",
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
