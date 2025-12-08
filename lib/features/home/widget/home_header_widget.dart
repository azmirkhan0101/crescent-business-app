import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/routes/app_pages.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/assets_path.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String userName;

  const HomeHeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              //TODO
              Get.toNamed(AppRoutes.profileSettings);
            },

            child: Row(
              children: [
                // User/Business Logo
                Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AssetsPath.businessProfileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                // Welcome text and user name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome Back!', style: AppTextStyle.mediumStyle),
                    SizedBox(height: 2.h),
                    Text(
                      userName,
                      style: AppTextStyle.headlineLStyle.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x199E9E9E),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomAssetsImage(assetsPath: AssetsPath.alertIcon),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(radius: 4.r, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
