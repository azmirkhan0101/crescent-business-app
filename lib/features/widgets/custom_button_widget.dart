import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/context_extension.dart';
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

  final bool isLoading;
  final Color loaderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.buttonTextStyle,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.widget,
    this.isLoading = false,
    this.loaderColor = AppColors.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // Use your primary color (or passed color) for both states
    // to prevent the "grey-out" effect during loading.
    final Color effectiveBgColor = backgroundColor ?? AppColors.primaryColor;
    bool isTab = context.isTab;

    return SizedBox(
      width: isTab ? width : width?.w,
      height: isTab ? 80 : height?.h ?? 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          // This prevents the button from turning grey when onPressed is null
          disabledBackgroundColor: effectiveBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        // Keep onPressed null to prevent double-taps while loading
        onPressed: isLoading ? null : onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading ? 0 : 1,
              child: widget ??
                  Text(
                    text,
                    style: buttonTextStyle,
                  ),
            ),
            if (isLoading) // Use conditional rendering for cleaner layout
              SizedBox(
                height: isTab ? 40 : 20.h,
                width:  isTab ? 40 : 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: loaderColor,
                  // Ensure no background color is set on the spinner itself
                  backgroundColor: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
