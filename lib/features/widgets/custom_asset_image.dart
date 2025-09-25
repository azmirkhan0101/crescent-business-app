import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomAssetsImage extends StatelessWidget {
  const CustomAssetsImage({
    super.key, required this.assetsPath,  this.width,  this.height, this.color,
  });
  final String assetsPath;
  final double ?width;
  final double ?height;
  final Color?color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      color: color,
      assetsPath,
      width:width??20.w,
      height: height??20.h,
    );
  }
}