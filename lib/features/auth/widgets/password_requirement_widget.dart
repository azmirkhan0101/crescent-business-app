import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../../utils/app_text.dart';

class PasswordRequirements extends StatefulWidget {

  final bool isEightCharacters;
  final bool isBothCasesPresent;
  final bool isNumeralPresent;
  final bool isSpecialCharPresent;
  const PasswordRequirements({
    super.key,
    required this.isEightCharacters,
    required this.isBothCasesPresent,
    required this.isNumeralPresent,
    required this.isSpecialCharPresent
  });

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
        _buildRequirementItem(AppText.passwordRequirementCharacters, widget.isEightCharacters),
        _buildRequirementItem(AppText.passwordRequirementLetters, widget.isBothCasesPresent),
        _buildRequirementItem(AppText.passwordRequirementNumber, widget.isNumeralPresent),
        _buildRequirementItem(AppText.passwordRequirementSpecial, widget.isSpecialCharPresent),
      ],
    );
  }

  // ✅ Pass a bool to control color
  Widget _buildRequirementItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if( isChecked )
            Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            ),
          if( !isChecked )
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.black,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text,
              style: AppTextStyle.mediumStyle.copyWith(
                fontSize: AppSizes.smallTSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

