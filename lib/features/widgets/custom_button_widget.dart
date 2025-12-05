import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_color.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final TextStyle buttonTextStyle;
  final Widget? widget;

  const CustomButton({
    super.key,

    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,

    this.widget, required this.text, required this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height?.h ?? 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: widget ??
            Text(
              text,
              style: buttonTextStyle

            ),
      ),
    );
  }
}
