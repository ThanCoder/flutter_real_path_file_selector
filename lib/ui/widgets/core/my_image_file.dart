import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants.dart';

class MyImageFile extends StatelessWidget {
  String path;
  String defaultAssetsPath;
  BoxFit fit;
  double? width;
  double? height;
  double borderRadius;

  MyImageFile({
    super.key,
    required this.path,
    this.defaultAssetsPath = defaultIconAssetsPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 5,
  });

  Widget _getImageWidget() {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, fit: fit, width: width, height: height);
    } else {
      return Image.asset(
        defaultAssetsPath,
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(color: Colors.white, child: _getImageWidget()),
      );
    }
    return Container(color: Colors.white, child: _getImageWidget());
  }
}
