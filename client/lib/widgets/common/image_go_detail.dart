import 'dart:async';

import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class ImageGoDetail extends StatefulWidget {
  final String imageUrl;

  const ImageGoDetail({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageGoDetail> createState() => _ImageGoDetailState();
}

class _ImageGoDetailState extends State<ImageGoDetail> {
  Completer<Image> _completer = Completer();

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Image.network()를 호출하여 이미지 객체를 가져옵니다.
  //   Image image = Image.network('https://example.com/image.jpg');
  //
  //   // 이미지 객체가 로드되면, Completer를 완료합니다.
  //   image.image.resolve(ImageConfiguration()).addListener(
  //         ImageStreamListener(
  //           (ImageInfo image, bool synchronousCall) {
  //             _completer.complete(image.image);
  //           },
  //           onError: (dynamic exception, StackTrace stackTrace) {
  //             _completer.completeError(exception);
  //           },
  //         ),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: widget.imageUrl,
        child: Image.network(
          widget.imageUrl,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImageDetailScreen(imageUrl: widget.imageUrl);
            },
          ),
        );
      },
    );
  }
}
