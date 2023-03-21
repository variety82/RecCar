import 'package:flutter/material.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value,
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                child: Icon(_isMenuOpen ? Icons.close : Icons.add),
              ),
            );
          },
        ),
        SizedBox(height: 20.0),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0.0, _translateAnimation.value * -1),
              child: child,
            );
          },
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.ac_unit),
          ),
        ),
        SizedBox(height: 20.0),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0.0, _translateAnimation.value * -2),
              child: child,
            );
          },
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.access_alarm),
          ),
        ),
      ],
    );
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isMenuOpen = !_isMenuOpen;
  }
}
