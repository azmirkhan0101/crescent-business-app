import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_card_widget.dart';

class ProfileRewardCardWidget extends StatelessWidget {
  const ProfileRewardCardWidget({
    super.key,
    required this.topIcon,
    required this.title,
    required this.subtitle,
    required this.bottomIcon1,
    required this.bottomIcon2,
    required this.bottomText,
  });

  final String topIcon;
  final String title;
  final String subtitle;
  final String bottomIcon1;
  final String bottomIcon2;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(topIcon, height: 24.h, width: 24.w),
              SizedBox(height: 8.w),

              /// Title
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: AppTextStyle.cardTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            subtitle,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 11.sp,
              color: Color(0xFF848484),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            bottomText,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 12.sp,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Image.asset(bottomIcon1, height: 16.h, width: 16.w),
              SizedBox(width: 6.w),
              Image.asset(bottomIcon2, height: 16.h, width: 24.w),
            ],
          ),
        ],
      ),
    );
  }
}
