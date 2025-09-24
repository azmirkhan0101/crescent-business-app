import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';
import '../../widgets/custom_button_widget.dart';

class UnderButtonWidget extends StatelessWidget {
  const UnderButtonWidget({
    super.key, required this.onPressed, required this.buttonText,
  });
  final void Function() onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
            text: buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}