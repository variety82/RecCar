import 'package:flutter/material.dart';

class ModalNavigator extends StatelessWidget {

  final Widget showedWidget;
  final Widget child;
  final bool disable;

  const ModalNavigator({
    super.key, required this.showedWidget, required this.child, required this.disable,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
        disable
          ? () {}
          : () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (BuildContext context) {
                return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    child: showedWidget
                );
              },
            );
          },
      child: child
    );
  }
}