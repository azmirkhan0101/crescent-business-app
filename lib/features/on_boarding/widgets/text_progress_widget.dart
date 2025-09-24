import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_text_styles.dart';
import '../../widgets/progress_indicator_widget.dart';


class TextProgressWidget extends StatelessWidget {
  const TextProgressWidget({
    super.key, required this.totalSteps, required this.currentStep, required this.title,
  });
 final int  totalSteps;
  final int  currentStep;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyle.headlineLStyle.copyWith(fontSize: 18.sp)),
        const SizedBox(height: 8),
        ProgressIndicatorWidget(totalSteps: totalSteps, currentStep: currentStep),
      ],
    );
  }
}