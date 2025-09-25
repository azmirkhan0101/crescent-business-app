import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import '../../utils/app_color.dart';

class TextFieldTitleWidget extends StatelessWidget {
  const TextFieldTitleWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      color: AppColors.blackTextColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    );
  }
}
