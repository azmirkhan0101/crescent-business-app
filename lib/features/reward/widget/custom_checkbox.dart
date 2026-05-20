import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';

import '../../../utils/app_color.dart';

class CustomCheckbox extends StatelessWidget {

  final String title;
  final bool isChecked;
  final Function(bool?) onChanged;

  const CustomCheckbox({super.key, required this.title, required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          checkColor: Colors.white,
          materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        SizedBox(width: 8.w),
        Text(//
          title,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: isTab ? 10.sp : 12.sp),
        ),
      ],
    );
  }
}

