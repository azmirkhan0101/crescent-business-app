import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/app_color.dart';

import '../../../../utils/app_text_styles.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    super.key,
    required this.firstText,
    required this.lastText,
    required this.onTap,
  });

  final String firstText;
  final String lastText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor
            ),
            //style: AppTextStyle.mediumStyle,
          ),
          TextSpan(
            text: lastText,
         style: GoogleFonts.familjenGrotesk(
           fontSize: 16.sp,
           fontWeight: FontWeight.w700,
           color: AppColors.headlineTColor
         ),
         //   style: AppTextStyle.headlineLStyle.copyWith(fontSize: 16.sp),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
