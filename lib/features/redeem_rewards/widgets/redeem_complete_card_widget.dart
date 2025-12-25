import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

class RedeemCompleteCardWidget extends StatelessWidget {

  final String title;
  final DateTime dateTime;
  final int redemptionCount;
  final String redemptionMethod;
  //FOR CHECKING REDEMPTION METHOD
  final String staticCode = "static-code";
  final String nfcTap = "nfc";
  final String qrCode = "qr";

  const RedeemCompleteCardWidget({
    super.key,
    required this.title,
    required this.dateTime,
    required this.redemptionCount,
    required this.redemptionMethod
  });

  @override
  Widget build(BuildContext context) {

    final formattedDateTime = DateFormat('d/M/yyyy - h:mm a')
        .format(dateTime);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      child: SizedBox(
        height: 152.h,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Assuming you have an asset for the badge
                  Image.asset(
                    AssetsPath.rankBadge2Icon,
                    width: 24.w,
                    height: 24.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter',
                      color: AppColors.blackTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Text(
                    'Redeemed On: ',
                    style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp),
                  ),
                  Text(
                    formattedDateTime,
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        redemptionCount.toString(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                          fontFamily: 'inter',
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
                    children: [
                      Text(
                        'Redeemed via',
                        style: AppTextStyle.mediumStyle.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Assuming you have an asset for the QR code
                      if( redemptionMethod == staticCode )
                      Image.asset(
                        AssetsPath.staticCodeIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                      if( redemptionMethod == qrCode )
                        Image.asset(
                          AssetsPath.qrCodeIcon,
                          width: 24.w,
                          height: 24.h,
                        ),
                      if( redemptionMethod == nfcTap )
                        Image.asset(
                          AssetsPath.nfcIcon,
                          width: 24.w,
                          height: 24.h,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
