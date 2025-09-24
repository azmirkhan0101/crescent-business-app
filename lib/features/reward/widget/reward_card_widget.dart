import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import 'custom_switch.dart';

// ---------------------- Reward Card ----------------------
enum RewardStatus { active, disabled }

class RewardCard extends StatefulWidget {
  final String title;
  final String assetIcon;
  final String expiryDate;
  final int redemptions;

  const RewardCard({
    super.key,
    required this.title,
    required this.expiryDate,
    required this.redemptions,
    required this.assetIcon,
  });

  @override
  State<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> {
  RewardStatus status = RewardStatus.active; // initial status

  @override
  Widget build(BuildContext context) {
    bool isActive = status == RewardStatus.active;

    return Container(
      height: 161.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          /// -------- Title + Popup --------
          Row(
            children: [
              Image.asset(
                widget.assetIcon, // ✅ fixed
                height: 24.h,
                width: 24.w,
              ),

              SizedBox(width: 8.w),
              Text(
                widget.title,
                style: AppTextStyle.cardTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),

              /// Popup menu
              PopupMenuButton<String>(
                color: AppColors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        CustomAssetsImage(
                          assetsPath: AssetsPath.editIcon,
                          color: AppColors.black,
                          height: 14.h,
                          width: 14.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Edit',
                          style: AppTextStyle.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        CustomAssetsImage(
                          assetsPath: AssetsPath.duplicateIcon,
                          height: 14.h,
                          width: 14.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Duplicate',
                          style: AppTextStyle.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        CustomAssetsImage(
                          assetsPath: AssetsPath.deleteIcon,
                          height: 14.h,
                          width: 14.w,
                          color: AppColors.blackTextColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Delete',
                          style: AppTextStyle.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {},
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// -------- Expiry + Switch --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expires: ${widget.expiryDate}',
                style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp),
              ),
              Row(
                children: [
                  Text(
                    isActive ? 'Active' : 'Disabled',
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Custom switch
                  CustomSwitch(
                    value: isActive,
                    onChanged: (bool newValue) {
                      setState(() {
                        status = newValue
                            ? RewardStatus.active
                            : RewardStatus.disabled;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// -------- Redemptions + QR --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.redemptions}",
                    style: AppTextStyle.headlineLStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'redemptions',
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Redeem via",
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  CustomAssetsImage(
                    assetsPath: AssetsPath.qrCodeIcon,
                    height: 24.h,
                    width: 24.w,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
