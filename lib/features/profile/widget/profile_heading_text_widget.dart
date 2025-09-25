import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_text_styles.dart';

class ProfileHeadingTextWidget extends StatelessWidget {
  const ProfileHeadingTextWidget({
    super.key, required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: AppTextStyle.headlineLStyle.copyWith(fontSize: 16.sp),);
  }
}
