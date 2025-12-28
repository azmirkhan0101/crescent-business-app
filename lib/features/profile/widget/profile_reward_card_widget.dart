import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/assets_path.dart';
import '../../widgets/custom_asset_image.dart';
import '../../widgets/custom_card_widget.dart';

class ProfileRewardCardWidget extends StatelessWidget {

  final String? image;
  final String title;
  final String? expiryDate;
  final String type;
  //INSTORE REDEMPTIONS
  final bool isQr;
  final bool isNfc;
  final bool isStaticCode;
  //ONLINE REDEMPTIONS
  final bool isGiftCard;
  final bool isDiscountCode;

  const ProfileRewardCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.expiryDate,
    required this.type,
    required this.isQr,
    required this.isNfc,
    required this.isStaticCode,
    required this.isGiftCard,
    required this.isDiscountCode,

  });

  @override
  Widget build(BuildContext context) {

    String imageUrl = "";
    if( image != null ){
      imageUrl = image!;
    }
    String? date;
    if( expiryDate != null ){
      DateTime dateTime = DateTime.parse( expiryDate! );
      date = "Expires: ${dateTime.toIso8601String().split('T')[0]}";
    }

    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.network(
                  imageUrl,
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      type == typeOnline
                          ? AssetsPath.onlineRewardIcon
                          : AssetsPath.instoreRewardIcon,
                      height: 24.h,
                      width: 24.w,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(width: 6.w),
              /// Title
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: AppTextStyle.cardTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            date ?? "",
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 11.sp,
              color: Color(0xFF848484),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Redeem via:",
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 12.sp,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            spacing: 7.w,
            children: [
              //ONLINE REDEMPTION ICONS
              if( isQr )//QR ICON
                CustomAssetsImage(
                  assetsPath: AssetsPath.qrCodeIcon,
                  height: 18.h,
                  width: 18.w,
                ),
              if( isStaticCode )//STATIC CODE
                CustomAssetsImage(
                  assetsPath: AssetsPath.staticCodeIcon,
                  height: 18.h,
                  width: 18.w,
                ),
              if( isNfc )//NFC
                CustomAssetsImage(
                  assetsPath: AssetsPath.nfcIcon,
                  height: 18.h,
                  width: 18.w,
                ),
              //INSTORE REDEMPTION ICONS
              if( isDiscountCode )//DISCOUNT CODE
                CustomAssetsImage(
                  assetsPath: AssetsPath.discountCodeIcon,
                  height: 18.h,
                  width: 18.w,
                ),
              if( isGiftCard )//GIFT CARD
                CustomAssetsImage(
                  assetsPath: AssetsPath.giftCardIcon,
                  height: 18.h,
                  width: 18.w,
                ),
            ],
          )
        ],
      ),
    );
  }
}
