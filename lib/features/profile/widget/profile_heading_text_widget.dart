import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/context_extension.dart';
import '../../../utils/app_text_styles.dart';

class ProfileHeadingTextWidget extends StatelessWidget {
  const ProfileHeadingTextWidget({
    super.key, required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Text(title,style: AppTextStyle.headlineLStyle.copyWith(fontSize: isTab ? 10.sp : 16.sp),);
  }
}
