import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/features/widgets/custom_text_field_widget.dart';
import 'package:organization/utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/app_text_styles.dart';

class HeadingTextWidget extends StatelessWidget {
  const HeadingTextWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.fontSize,
  });
  final double? fontSize;
  final String title;
  final String subTitle;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title,
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: AppColors.headlineTColor,
          language: true,
        ),

        SizedBox(height: AppSizes.paddingSmallH),
        CustomText(text: subTitle,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.secondaryTextColor,
          language: false,
        ),


      ],
    );
  }
}
