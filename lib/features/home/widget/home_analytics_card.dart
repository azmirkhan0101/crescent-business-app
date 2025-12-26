import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';

import '../../widgets/custom_card_widget.dart';

class HomeAnalyticsCard extends StatelessWidget {

  final String timeLine;
  final int count;
  final double percentage;
  final bool isIncrease;

  const HomeAnalyticsCard({
    super.key,
    required this.timeLine,
    required this.count,
    required this.percentage,
    required this.isIncrease,
  });


  @override
  Widget build(BuildContext context) {

    String percentageText =
    percentage % 1 == 0
        ? percentage.toInt().toString()
        : percentage.toString();


    return CustomCard(
      height: 162.h,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Icon
          SvgPicture.asset(
            Assets.icons.scanQrCode,
              colorFilter: ColorFilter.mode(Color(0xFFC08FFF), BlendMode.srcIn),
              height: 24.h,
              width: 24.w
          ),

          SizedBox(height: 8.h),

          /// Title
          Text(
              'Redemptions',
              style: AppTextStyle.cardTextStyle
          ),
          SizedBox(height: 4.h),

          //TIMELINE
          Text(
            timeLine,
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
