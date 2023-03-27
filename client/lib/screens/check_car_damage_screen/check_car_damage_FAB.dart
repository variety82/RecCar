import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:client/widgets/register/register_line.dart';
import 'package:client/widgets/register/register_title.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter_modal.dart';
import 'package:client/screens/check_car_damage_screen/check_car_damage_filter.dart';

class MyFABMenu extends StatefulWidget {
  final void Function(String) addCategories;
  final void Function(String) removeCategories;
  final List<String> selected_categories;

  const MyFABMenu({
    super.key,
    required this.selected_categories,
    required this.addCategories,
    required this.removeCategories,
  });

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
      overlayOpacity: 0.0,
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
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    child: CheckCarDamageFilterModal(
                      selected_categories: widget.selected_categories,
                      addCategories: widget.addCategories,
                      removeCategories: widget.removeCategories,
                      // showedWidget: CheckCarDamagefilter(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
