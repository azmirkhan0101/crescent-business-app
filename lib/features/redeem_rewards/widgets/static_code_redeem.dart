import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/core/routes/route_path.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../widgets/custom_card_widget.dart';
import 'apply_widget.dart';

class StaticCodeWidget extends StatelessWidget {
  const StaticCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Enter Redeem Code",
            style: AppTextStyle.headlineLStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          CustomCard(
            height: 52.h,
            width: 279.w,
            child: Center(
              child: Text(
                "SWB-QR-9842736590",
                style: AppTextStyle.mediumStyle.copyWith(
                  color: AppColors.buttonTextColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ApplyWidget(
            onPressed: () {
              context.push(RoutesPath.boardingStore);
            },
          ),
        ],
      ),
    );
  }
}
