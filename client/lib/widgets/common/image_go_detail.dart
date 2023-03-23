import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class ImageGoDetail extends StatefulWidget {
  final String imageUrl;

  const ImageGoDetail({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageGoDetail> createState() => _ImageGoDetailState();
}

class _ImageGoDetailState extends State<ImageGoDetail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: widget.imageUrl,
        child: Image.network(widget.imageUrl),
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
