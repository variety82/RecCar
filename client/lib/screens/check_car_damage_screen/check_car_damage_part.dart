import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_go_detail.dart';

class CheckCarDamagePart extends StatelessWidget {
  final String imageUrl;

  const CheckCarDamagePart({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF999999).withOpacity(0.5),
            spreadRadius: 0.3,
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(20),
        // color: Colors.black,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageGoDetail(
              imageUrl: imageUrl,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                  ),
                  Text(
                    ' 타임 스탬프',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 16,
                  ),
                  Text(
                    ' 손상 종류',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.car_crash,
                    size: 16,
                  ),
                  Text(
                    ' 차량 부위',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
