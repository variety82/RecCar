import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class CheckCarDamageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.48, // Container 높이 설정
        child: RawScrollbar(
          thumbVisibility: true,
          radius: Radius.circular(5),
          thumbColor: Color(0xFFE0426F),
          thickness: 4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
                  ),
                ),
                Image.network(
                  'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
                ),
                Image.network(
                  'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Center(
//   child: GestureDetector(
//     child: Hero(
//       tag: 'imageHero',
//       child: Column(
//         children: [
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//           Image.network(
//             'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg',
//           ),
//         ],
//       ),
//     ),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) {
//             return ImageScreen(
//                 imageUrl:
//                     'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/damage_frame1.jpg');
//           },
//         ),
//       );
//     },
//   ),
// ),
