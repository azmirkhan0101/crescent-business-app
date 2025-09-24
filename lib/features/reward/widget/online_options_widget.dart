import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_color.dart';

import 'add_discount_codes_section.dart';
import 'expiry_limit_section.dart';
import 'link_preview_box_widget.dart';

class OnlineOptions extends StatefulWidget {
  const OnlineOptions({super.key});

  @override
  State<OnlineOptions> createState() => _OnlineOptionsState();
}

class _OnlineOptionsState extends State<OnlineOptions> {
  bool isDiscountCodeChecked = true;
  bool isGiftCardChecked = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Discount Code
        CustomCard(
          height: 52.h,
          child: _buildCheckboxRow(
            'Discount Code',
            isDiscountCodeChecked,
                (val) => setState(() => isDiscountCodeChecked = val ?? false),
          ),
        ),
        SizedBox(height: 8.h),

        /// Gift Card
        CustomCard(
          height: 52.h,
          child: _buildCheckboxRow(
            'Gift Card',
            isGiftCardChecked,
                (val) => setState(() => isGiftCardChecked = val ?? false),
          ),
        ),

        const SizedBox(height: 25),
        const AddDiscountCodesSection(),
      ],
    );
  }

  Widget _buildCheckboxRow(
      String title,
      bool isChecked,
      Function(bool?) onChanged,
      ) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        SizedBox(width: 8.w,),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
