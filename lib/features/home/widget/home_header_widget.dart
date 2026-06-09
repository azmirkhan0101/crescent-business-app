import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/app_text_styles.dart';

class HomeHeaderWidget extends StatelessWidget {

  final String? profileImageUrl;
  final String? userName;
  final bool isTab;

  const HomeHeaderWidget({
    super.key,
    required this.profileImageUrl,
    required this.userName, required this.isTab
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.profileSettings);
            },
            child: Row(
              children: [
                Container(
                  width: isTab ? 80 : 45.w,
                  height: isTab ? 80 : 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval( child: buildProfileImage() ),
                ),
                const SizedBox(width: 12),
                // Welcome text and user name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome Back!', style: isTab ? TextStyle(fontSize: 12.sp) : AppTextStyle.mediumStyle),
                    SizedBox(height: 2.h),
                    Text(
                      userName == null || userName!.isEmpty ? "User"  : userName!,
                      style: AppTextStyle.headlineLStyle.copyWith(
                        fontSize: isTab ? 12.sp : 20.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification icon
          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.notification);
            },
            child: Container(
              width: isTab ? 80 : 40.w,
              height: isTab ? 80 : 40.h,
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
                  // CustomAssetsImage(
                  //     assetsPath: AssetsPath.alertIcon
                  // ),
                  SvgPicture.asset(Assets.icons.notification, height: 25.h, width: 25.w,),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(radius: isTab ? 6 : 4.r, backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  //BUILD PROFILE IMAGE
  Widget buildProfileImage() {
    if ( profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profileImageUrl!,
        fit: BoxFit.cover,
        // This creates the "shimmering" gray box while loading
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.business),
      );
    }
    //return Icon(Icons.business, size: 50.r, color: Colors.grey);
    return Icon(Icons.business, size: 50.r, color: Colors.grey);
  }
}
