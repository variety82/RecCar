import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:client/widgets/common/image_detail.dart';

class ImageGoDetail extends StatefulWidget {
  final String imagePath;
  final String imageCase;

  const ImageGoDetail({
    Key? key,
    required this.imagePath,
    required this.imageCase,
  }) : super(key: key);

  @override
  State<ImageGoDetail> createState() => _ImageGoDetailState();
}

class _ImageGoDetailState extends State<ImageGoDetail> {
  File? _imageFile;

  @override
  void initState() {
    if (widget.imagePath != '') {
      setState(() {
        _imageFile = File(widget.imagePath);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: widget.imagePath,
        child: widget.imageCase == 'url'
            ? Image.network(
                widget.imagePath,
                fit: BoxFit.contain,
              )
            : RotatedBox(
                quarterTurns: 3,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImageDetailScreen(
                imagePath: widget.imagePath,
                imageCase: widget.imageCase,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImagePreview(File file) {
    final image = Image.file(file);

    final imageWidth = image.width;
    final imageHeight = image.height;

    if (imageHeight! > imageWidth!) {
      return Transform.rotate(
        angle: 90 * (3.1415926535897932 / 180),
        child: Image.file(file),
      );
    }
    return image;
  }
}
