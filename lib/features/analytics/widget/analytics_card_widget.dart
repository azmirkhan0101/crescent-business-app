import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';

import '../../widgets/custom_card_widget.dart';

class AnalyticsCardWidget extends StatelessWidget {
  const AnalyticsCardWidget({
    super.key,
    required this.topIcon,
    required this.title,
    required this.subtitle,
    required this.bottomText,
    required this.bottomEndText,
    this.topIconColor,
    required this.isIncrease,
  });
  final String topIcon;
  final String bottomEndText;
  final String title;
  final String subtitle;
  final String bottomText;
  final Color? topIconColor;
  final bool isIncrease;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 162.h,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Icon
          Image.asset(topIcon, color: topIconColor, height: 24.w, width: 24.w),

          SizedBox(height: 8.h),

          /// Title
          Text(title, style: AppTextStyle.cardTextStyle),
          SizedBox(height: 4.h),

          /// Subtitle
          Text(
            subtitle,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 12.sp,
              color: Color(0xFF848484),
            ),
          ),

          const Spacer(),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: bottomText,
              fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColors.headlineTColor,
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  CustomText(text: bottomEndText,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.blackTextColor,
                    language: false,
                  ),
                  SizedBox(width: 4.w),
                  Image.asset(
                      isIncrease ? AssetsPath.increaseIcon : AssetsPath.decreaseIcon,
                      height: 14.w,
                      width: 14.w
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
