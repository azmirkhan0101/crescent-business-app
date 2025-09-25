import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';

class ApplyWidget extends StatelessWidget {
  const ApplyWidget({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.blackTextColor, width: 1.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding:  EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
      ),
      child: CustomText(text: "Apply",
      fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.blackTextColor,
      ),

      // Text(
      //   'Apply',
      //   style: AppTextStyle.mediumStyle.copyWith(
      //     fontWeight: FontWeight.w600,
      //     color: AppColors.blackTextColor,
      //   ),
      // ),
    );
  }
}
