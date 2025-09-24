import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressIndicatorWidget({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 4.h,
          width: 24.w,
          decoration: BoxDecoration(
            color: index < currentStep
                ? AppColors.primaryColor
                : Color(0xFFEBE9EC),
            borderRadius: BorderRadius.circular(24.r),
          ),
        );
      }),
    );
  }
}
