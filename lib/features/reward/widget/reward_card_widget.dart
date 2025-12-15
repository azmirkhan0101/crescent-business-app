import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';
import 'custom_switch.dart';

class RewardCard extends StatefulWidget {
  final String title;
  final String? expiryDate;
  final int redemptions;
  final bool isActive;
  final String type;
  //INSTORE REDEMPTIONS
  final bool isQr;
  final bool isNfc;
  final bool isStaticCode;
  //ONLINE REDEMPTIONS
  final bool isGiftCard;
  final bool isDiscountCode;
  final VoidCallback onDeleteClick;
  final Function(bool) onStatusChanged;

  const RewardCard({
    super.key,
    required this.title,
    required this.expiryDate,
    required this.redemptions,
    required this.isActive,
    required this.type,
    this.isQr = false,
    this.isNfc = false,
    this.isStaticCode = false,
    this.isGiftCard = false,
    this.isDiscountCode = false,
    required this.onDeleteClick,
    required this.onStatusChanged,
  });

  @override
  State<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> {
  late String? date;

  @override
  void initState() {

    if( widget.expiryDate != null ){
      DateTime dateTime = DateTime.parse( widget.expiryDate! );
      date = "Expires: ${dateTime.toIso8601String().split('T')[0]}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                widget.type == typeOnline ? AssetsPath.onlineRewardIcon : AssetsPath.instoreRewardIcon,
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
                    value: edit,
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
                  //DUPLICATE OPTION IS DISABLED
                  // PopupMenuItem(
                  //   value: duplicate,
                  //   child: Row(
                  //     children: [
                  //       CustomAssetsImage(
                  //         assetsPath: AssetsPath.duplicateIcon,
                  //         height: 14.h,
                  //         width: 14.w,
                  //       ),
                  //       SizedBox(width: 8.w),
                  //       Text(
                  //         'Duplicate',
                  //         style: AppTextStyle.cardTextStyle.copyWith(
                  //           fontSize: 12.sp,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: delete,
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
                onSelected: (value) {
                  if( value.compareTo( edit ) == 0 ){//EDIT CLICKED
                    //TODO: EDIT REWARD
                    Get.toNamed( AppRoutes.editReward );
                  }else{//DELETE CLICKED
                    //DELETE REWARD
                    widget.onDeleteClick();
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// -------- Expiry + Switch --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date ?? "",
                style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp),
              ),
              Row(
                children: [
                  Text(
                    widget.isActive ? 'Active' : 'Disabled',
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Custom switch
                  CustomSwitch(
                    value: widget.isActive,
                    onChanged: (bool newValue) {
                      widget.onStatusChanged( newValue );
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
                  Row(
                    spacing: 10.w,
                    children: [
                      //ONLINE REDEMPTION ICONS
                      if( widget.isQr )//QR ICON
                        CustomAssetsImage(
                          assetsPath: AssetsPath.qrCodeIcon,
                          height: 28.h,
                          width: 28.w,
                        ),
                      if( widget.isStaticCode )//STATIC CODE
                      CustomAssetsImage(
                        assetsPath: AssetsPath.staticCodeIcon,
                        height: 24.h,
                        width: 24.w,
                      ),
                      if( widget.isNfc )//NFC
                        CustomAssetsImage(
                          assetsPath: AssetsPath.nfcIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                      //INSTORE REDEMPTION ICONS
                      if( widget.isDiscountCode )//DISCOUNT CODE
                        CustomAssetsImage(
                          assetsPath: AssetsPath.discountCodeIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                      if( widget.isGiftCard )//GIFT CARD
                        CustomAssetsImage(
                          assetsPath: AssetsPath.giftCardIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                    ],
                  )

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
