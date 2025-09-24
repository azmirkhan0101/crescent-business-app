


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/assets_path.dart';
import '../../widgets/custom_card_widget.dart';



class AnalyticsCardWidget extends StatelessWidget {
  const AnalyticsCardWidget({
    super.key,
    required this.topIcon,
    required this.bottomIcon,
    required this.title,
    required this.subtitle,
    required this.bottomText, required this.bottomEndText, this.topIconColor,
  });
  final String topIcon;
  final String bottomIcon;
  final String bottomEndText;
  final String title;
  final String subtitle;
  final String bottomText;
  final Color?topIconColor;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 162.h,
       color: AppColors.white,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Icon
          Image.asset(
            topIcon,
            color: topIconColor,
            height: 24.w,
            width: 24.w,
          ),

          SizedBox(height: 8.h),

          /// Title
          Text(
              title,
              style:AppTextStyle.cardTextStyle),
          SizedBox(height: 4.h),
          /// Subtitle
          Text(
              subtitle,
              style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp,color: Color(0xFF848484))
          ),

          const Spacer(),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  bottomText,
                  style:AppTextStyle.headlineLStyle.copyWith(fontSize: 24.sp)
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  Text(bottomEndText,
                      style:AppTextStyle.mediumStyle.copyWith(color: AppColors.blackTextColor)
                  ),
                  SizedBox(width: 4.w,),
                  Image.asset(
                    bottomIcon,
                    height: 14.w,
                    width: 14.w,
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