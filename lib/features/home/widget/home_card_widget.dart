import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_card_widget.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    super.key, required this.topIcon, required this.title, required this.bottomText,
  });
  final String topIcon;
  final String title;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 162.h,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  /// Top Icon
            Image.asset(
              topIcon,
              color: Color(0xFFFE70B7),
              height: 24.w,
              width: 24.w,
            ),
            SizedBox(height: 8.h),

            /// Title
            CustomText(text: title,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: AppColors.blackTextColor,
             language: false,
            ),




          ],
        ),
        Spacer(),
        CustomText(text: bottomText,
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: AppColors.headlineTColor,
          language: true,
        ),

      ],),);
  }
}