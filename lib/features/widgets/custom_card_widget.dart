import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  const CustomCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      color: color ?? AppColors.white,
      elevation: 2, // shadow
      shadowColor: const Color(0x05000000), // #00000005 (2% opacity)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: const Color(0xFFE4E4E4),
          width: 1.w,
        ),
      ),
      child: Container(
       // height: height,
        height: height ,
        width: width,
        padding: padding ?? EdgeInsets.all(16.w),
        alignment: alignment, //
        child: child,
      ),
    );
  }
}
