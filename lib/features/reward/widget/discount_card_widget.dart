import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../widgets/custom_asset_image.dart';
import '../../widgets/custom_card_widget.dart';

class DiscountCardWidget extends StatelessWidget {
  const DiscountCardWidget({
    super.key,
    this.icon1,
    this.icon2,
    required this.text,
    this.textStyle,
  });
  final String? icon1;
  final String? icon2;
  final String text;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 52.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomAssetsImage(
                assetsPath: icon1.toString(),
                color: AppColors.black,
              ),
              SizedBox(width: 4.w),
              Text(
                text,
                style:
                    textStyle ??
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              ),
            ],
          ),

          Row(
            children: [
              Container(width: 2, height: 20, color: Colors.grey.shade400),
              SizedBox(width: 4.w),
              CustomAssetsImage(
                assetsPath: icon2.toString(),
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
