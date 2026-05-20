import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_card_widget.dart';
import '../../widgets/text_field_title_widget.dart';

class AddDiscountCodesSection extends StatelessWidget {
  final VoidCallback onPickFile;      // When user taps upload
  final VoidCallback onDelete;        // When user taps delete
  final String? fileName;             // The picked file name

  const AddDiscountCodesSection({
    super.key,
    required this.onPickFile,
    required this.onDelete,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;
    final titleToShow = fileName ?? "Discount Codes";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Add discount code(s)"),

        const SizedBox(height: 5),

        Text(
          'Upload via .csv or add a URL to the gift card system',
          style: AppTextStyle.mediumStyle.copyWith(fontSize: isTab ? 8.sp : 12.sp),
        ),
        SizedBox(height: 10.h),

        CustomCard(
          height: isTab ? 90 : 52.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.upload , size: isTab ? 40 : null,),
                  SizedBox(width: 4.w),

                  GestureDetector(
                    onTap: onPickFile,
                    child: Text(
                      titleToShow,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTab ? 10.sp : 14.sp,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(width: 2, height: 20, color: Colors.grey.shade400),
                  SizedBox(width: 4.w),

                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, size: isTab ? 40 : null,),
                    color: AppColors.errorRed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
