import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/on_boarding/widgets/text_progress_widget.dart';

import '../../../utils/assets_gen/assets.gen.dart';

class OnBoardingAppbarWidget extends StatelessWidget {
  const OnBoardingAppbarWidget({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.title,
    this.suffix,
  });
  final int totalSteps;
  final int currentStep;
  final String title;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: isTab ? 60 : 40,
            width: isTab ? 60 : 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F4F6),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.backIcon,
                height: isTab ? 40 : 20.h,
                width: isTab ? 40 : 19.w,
              ),
            ),
          ),
        ),
        TextProgressWidget(
          totalSteps: totalSteps,
          currentStep: currentStep,
          title: title,
        ),
        suffix ?? SizedBox(),
      ],
    );
  }
}
