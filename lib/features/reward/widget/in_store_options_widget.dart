import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_color.dart';

class InStoreOptions extends StatefulWidget {
  const InStoreOptions({super.key});

  @override
  State<InStoreOptions> createState() => _InStoreOptionsState();
}

class _InStoreOptionsState extends State<InStoreOptions> {
  bool isDiscountCodeChecked = true;
  bool isGiftCardChecked = true;
  bool isStaticCodeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          height: 52.h,
          child: _buildCheckboxRow(
            'Discount Code',
            isDiscountCodeChecked,
                (val) => setState(() => isDiscountCodeChecked = val ?? false),
          ),
        ),
        SizedBox(height: 8.h),
        CustomCard(
          height: 52.h,
          child: _buildCheckboxRow(
            'Gift Card',
            isGiftCardChecked,
                (val) => setState(() => isGiftCardChecked = val ?? false),
          ),
        ),
        SizedBox(height: 8.h),
        CustomCard(
          height: 52.h,
          child: _buildCheckboxRow(
            'Static Code',
            isStaticCodeChecked,
                (val) => setState(() => isStaticCodeChecked = val ?? false),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRow(
      String title,
      bool isChecked,
      Function(bool?) onChanged,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // বড় padding কেটে যাবে
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),SizedBox(width: 8.w,),
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
