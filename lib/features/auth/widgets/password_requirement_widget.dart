import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../../utils/app_text.dart';

class PasswordRequirements extends StatefulWidget {
  const PasswordRequirements({super.key});

  @override
  State<PasswordRequirements> createState() => _PasswordRequirementsState();
}

class _PasswordRequirementsState extends State<PasswordRequirements> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "A strong password must have:",
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.secondaryTextColor,
        ),
        SizedBox(height: 8.h),
        _buildRequirementItem(AppText.passwordRequirementCharacters, false),
        _buildRequirementItem(AppText.passwordRequirementLetters, true),
        _buildRequirementItem(AppText.passwordRequirementNumber, true),
        _buildRequirementItem(AppText.passwordRequirementSpecial, false),
      ],
    );
  }

  // ✅ Pass a bool to control color
  Widget _buildRequirementItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isChecked ? Colors.green : Colors.transparent, // ✅ use passed bool
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: AppSizes.smallTSize,
            ),
          ),
        ],
      ),
    );
  }
}

