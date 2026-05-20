import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  final bool isEnabled;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.isEnabled,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: SvgPicture.asset(
          svgIconPath,
          width: isTab ? 60 : 28.w,
          height: isTab ? 60 : 28.h,
        ),
        title: CustomText(
          textAlign: TextAlign.start,
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: isTab ? 12.sp : 14,
        ),
        subtitle: CustomText(
          maxLines: 8,
          textAlign: TextAlign.start,
          text: subtitle,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF808080),
          fontSize: isTab ? 12.sp : 14,
        ),
        trailing: SizedBox(
          width: isTab ? 80 : 50.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. The Switch
              Switch(
                value: isEnabled,
                // Disable the switch UI while loading is true
                onChanged: isLoading ? null : onChanged,
                activeColor: AppColors.primaryColor,
              ),
              // 2. The Loading Indicator (positioned over the thumb)
              if (isLoading)
                Positioned(
                  // If enabled (ON), thumb is on the right. If disabled (OFF), thumb is on the left.
                  right: isEnabled ? isTab ? 20 : 6.w : null,
                  left: !isEnabled ? isTab ? 20 : 6.w : null,
                  child: SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      // Contrast color: White when on Primary, Primary when on Grey
                      color: isEnabled ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}