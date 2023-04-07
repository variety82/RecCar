import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MainPageBody extends StatefulWidget {

  final String imgRoute;
  final Widget mainContainter;
  final bool imageDisabled;

  const MainPageBody({
    super.key, required this.imgRoute, required this.mainContainter, required this.imageDisabled,
  });


  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Stack(
            children: [
              Center(
                child:
                SvgPicture.asset(
                  widget.imgRoute,
                  height: screenHeight * 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 180,
                ),
                child:
                  widget.imageDisabled
                    ? Center(
                      child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: const Icon(Icons.add_box_rounded)),
                      )
                    : null
              ),
            ]
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.mainContainter,
              SizedBox(
                height: screenHeight * 0.04,
              )
            ],
          )
        )
      ],
    );
  }
}