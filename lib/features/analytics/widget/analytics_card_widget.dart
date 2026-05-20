import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../../core/context_extension.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_card_widget.dart';

class AnalyticsCardWidget extends StatelessWidget {

  final bool isProfileViewsCard;
  final String timeLine;
  final int count;
  final double percentage;
  final bool isIncrease;

  const AnalyticsCardWidget({
    super.key,
    required this.isProfileViewsCard,
    required this.timeLine,
    required this.count,
    required this.percentage,
    required this.isIncrease,
  });


  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    String percentageText =
    percentage % 1 == 0
        ? percentage.toInt().toString()
        : percentage.toString();


    return CustomCard(
      height: isTab ? 300 : 162.h,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Icon
          SvgPicture.asset(
              isProfileViewsCard ? Assets.icons.profileIcon : Assets.icons.clickIcon,
              //color: topIconColor,
              height: isTab ? 40 : 24.h,
              width: isTab ? 40 : 24.w
          ),

          SizedBox(height: 8.h),

          /// Title
          Text(
              isProfileViewsCard ? "Profile Views" : "Website Visits",
              style: AppTextStyle.cardTextStyle.copyWith(fontSize: isTab ? 10.sp : null)
          ),
          SizedBox(height: 4.h),

          //TIMELINE
          Text(
            timeLine,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: isTab ? 8.sp : 12.sp,
              color: Color(0xFF848484),
            ),
          ),

          const Spacer(),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //VIEWS COUNT
              CustomText(
                text: "$count",
              fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColors.headlineTColor,
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  //PERCENTAGE
                  CustomText(
                    text: "$percentageText %",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.blackTextColor,
                    language: false,
                  ),
                  SizedBox(width: 4.w),
                  //INCREASE - DECREASE ICON
                  SvgPicture.asset(
                      isIncrease ? Assets.icons.increaseIcon : Assets.icons.decreaseIcon,
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
