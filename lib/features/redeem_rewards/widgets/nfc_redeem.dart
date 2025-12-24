import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/redeem/redeem_controller.dart';
import 'package:organization/utils/app_color.dart';
import '../../../utils/assets_path.dart';

class NFCWidget extends StatelessWidget {

  final RedeemController redeemController = Get.find<RedeemController>();
  NFCWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h, left: 43.w, right: 43.w),
      child: SizedBox(
        height: 409.h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Image
            Image.asset(
              AssetsPath.vectorCoverImage,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),

            // NFC icon + text
            Positioned(
              top: 80.h,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      redeemController.startNfcRead();
                    },
                    child: Image.asset(
                      AssetsPath.nfcIcon,
                      height: 48.h,
                      width: 48.w,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap to redeem',
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx((){
                    return Text(
                      'NFC tag: ${redeemController.nfcTag.value}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
