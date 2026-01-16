import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import 'package:organization/utils/assets_path.dart';
import 'package:shimmer/shimmer.dart';

class RedeemCompleteCardWidget extends StatelessWidget {

  final String title;
  final String image;
  final DateTime dateTime;
  final int redemptionCount;
  final String redemptionMethod;
  //FOR CHECKING REDEMPTION METHOD
  final String staticCode = "static-code";
  //final String nfcTap = "nfc";
  final String qrCode = "qr";

  const RedeemCompleteCardWidget({
    super.key,
    required this.title,
    required this.dateTime,
    required this.redemptionCount,
    required this.redemptionMethod,
    required this.image
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
                  Container(
                    height: 25.h,
                    width: 25.w,
                    child: rewardImage( image ),
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
                      if( redemptionMethod != staticCode && redemptionMethod != qrCode )
                        Image.asset(
                          AssetsPath.qrCodeIcon,
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

  rewardImage( String imageUrl ){

    if( imageUrl.isEmpty ){
      return Image.asset(AssetsPath.rankBadge2Icon, fit: BoxFit.cover);
    }else{
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(AssetsPath.rankBadge2Icon, fit: BoxFit.cover)
      );
    }
  }
}
