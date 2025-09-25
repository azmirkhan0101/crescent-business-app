import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_size.dart';

class AppTextStyle {
  static TextStyle headlineLStyle = GoogleFonts.familjenGrotesk(
    fontWeight: FontWeight.bold,
    fontSize: AppSizes.bodyL,
    color: AppColors.headlineTColor,
  );
  static TextStyle mediumStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: AppSizes.mediumTSize,
    color: AppColors.secondaryTextColor,
  );

  static TextStyle buttonTextStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: AppSizes.buttonTSize,
    color: AppColors.buttonTextColor,
  );

  static TextStyle cardTextStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    color: AppColors.blackTextColor,
  );

  static final TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.black,
  );

  static final title = GoogleFonts.familjenGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final subtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  );

  static final buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
