import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';


class RewardListItem extends StatelessWidget {
  final String rewardText;
  final double percentage;
  final bool isGrowth;
  final String assetsIcon;
  const RewardListItem({
    super.key,
    required this.rewardText,
    required this.percentage,
    required this.isGrowth,
    required this.assetsIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Color(0x80F2F2F2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Left side: Icon and text
          CustomAssetsImage(assetsPath: assetsIcon),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              rewardText,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                 color: AppColors.blackTextColor
              ),




            ),
          ),
          // Right side: Percentage and arrow
          Row(
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackTextColor
                ),
              ),
              const SizedBox(width: 4.0),
              CustomAssetsImage(
                assetsPath: AssetsPath.increaseIcon,
                height: 14.h,
                width: 14.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Example of how to use this widget
// In your main widget's build method:
/*
Column(
  children: const [
    RewardListItem(
      rewardText: '10% Off Latte',
      percentage: 40.2,
      isGrowth: true,
    ),
    RewardListItem(
      rewardText: 'Free Muffin',
      percentage: 15.5,
      isGrowth: false,
    ),
  ],
)
*/
