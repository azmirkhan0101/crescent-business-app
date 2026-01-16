import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final Color prefixIconColor;
  final IconData? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final EdgeInsetsGeometry? padding;
  final double buttonRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? iconSize;
  final double borderWidth;

  const ButtonWidget({
    super.key,
    required this.label,
    this.icon,
    this.prefixIcon,
    this.prefixIconColor = AppColors.white,
    this.iconHeight,
    this.iconWidth,
    this.textColor = AppColors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.onPressed,
    this.buttonHeight = 56,
    this.buttonWidth = 200,
    this.padding,
    this.buttonRadius = 100,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.iconSize,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight.h,
      width: buttonWidth.w,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.black,
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius.r)),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth.r,
        ),
      ),
      child: MaterialButton(
        padding: padding,
        onPressed: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Icon(prefixIcon,
                color: prefixIconColor,
                size: 20.r,
              ),
            if (prefixIcon != null) SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(color: textColor,
                fontSize: fontSize.sp,
                fontWeight: fontWeight,),
            ),
            if (icon != null) const SizedBox(width: 12),
            if (icon != null)
              Icon(
                icon,
                color: iconColor ?? textColor,
                size: iconSize ?? fontSize,
              ),
          ],
        ),
      ),
    );
  }
}
