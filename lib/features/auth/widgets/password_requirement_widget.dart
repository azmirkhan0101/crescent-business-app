import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../../utils/app_text.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('A strong password must have:', style: AppTextStyle.mediumStyle),
        SizedBox(height: 8.h),
        _buildRequirementItem(AppText.passwordRequirementCharacters),
        _buildRequirementItem(AppText.passwordRequirementLetters),
        _buildRequirementItem(AppText.passwordRequirementNumber),
        _buildRequirementItem(AppText.passwordRequirementSpecial),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
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
