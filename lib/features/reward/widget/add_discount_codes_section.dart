import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final titleToShow = fileName ?? "Discount Codes";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Add discount code(s)"),

        const SizedBox(height: 5),

        Text(
          'Upload via .csv or add a URL to the gift card system',
          style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp),
        ),
        SizedBox(height: 10.h),

        CustomCard(
          height: 52.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.upload),
                  SizedBox(width: 4.w),

                  GestureDetector(
                    onTap: onPickFile,
                    child: Text(
                      titleToShow,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
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
                    icon: const Icon(Icons.delete),
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
