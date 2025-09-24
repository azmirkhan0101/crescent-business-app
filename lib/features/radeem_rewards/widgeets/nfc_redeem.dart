import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';
import '../../../utils/assets_path.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h, left: 43.w, right: 43.w), // 🔥 fixed gap
      child: SizedBox(
        height: 409.h,
        width: double.infinity, // width এখন responsive হবে
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Image
            Image.asset(
              AssetsPath.vectorCoverImage,
              fit: BoxFit.contain, // crop হবে না
              width: double.infinity,
              height: double.infinity,
            ),

            // NFC icon + text
            Positioned(
              top: 80.h,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
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
                      fontSize: 32.sp,
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

