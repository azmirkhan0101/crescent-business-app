import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../utils/app_size.dart';

class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color iconBgColor;
  final double? height;
  final double? width;

  // Gradient colors required
  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.gradientColor1,
    required this.gradientColor2,
    required this.gradientColor3,
    this.height,
    this.width,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 144.h,
      width: width,
      padding: EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientColor1, gradientColor2, gradientColor3],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                icon,
                color: iconColor,
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.headlineLStyle.copyWith(fontSize: 16.sp),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: AppTextStyle.mediumStyle.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.blackTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
