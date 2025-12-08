import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/features/profile/widget/business_profile_image_widget.dart';
import 'package:organization/features/widgets/button_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        clipBehavior: Clip.none,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Profile',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.blackTextColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          ///profile header section
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(height: 16.h),

                Container(
                  width: 80.w,
                  height: 80.w, // keep it square for circle
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.91.w,
                      color: const Color(0xFFE4E4E4),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.r),
                    child: Image.asset(
                      AssetsPath.businessProfileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CustomText(
                  text: "Talha S.",
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000C0B),
                ),

                SizedBox(height: 4.h),

                CustomText(
                  text: "talha@gmail.com",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          ///profile other field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _buildProfileOption(
                  title: "Notification",
                  icon: Icons.notifications_none_outlined,
                  onTap: () {
                    Get.toNamed(AppRoutes.notification);
                  },
                ),

                _buildProfileOption(
                  title: "Change Password",
                  icon: Icons.lock_outline,
                  onTap: () {
                    Get.toNamed(AppRoutes.changePassword);
                  },
                ),

                _buildProfileOption(
                  title: "Subscriptions",
                  icon: Icons.subscriptions_outlined,
                  onTap: () {
                    Get.toNamed(AppRoutes.subscription);
                  },
                ),
                _buildProfileOption(
                  title: "Terms & Conditions",
                  icon: Icons.info_outline,
                  onTap: () {
                    Get.toNamed(AppRoutes.termsCondition);
                  },
                ),
              ],
            ),
          ),

          ///button
          SizedBox(height: 24.h),
          ButtonWidget(
            label: "Logout",
          buttonHeight: 45,
          textColor: Color(0xFFE6283C),
            buttonRadius: 12,
            backgroundColor: Color(0xFFFFE6E6),
            borderColor: Color(0xFFE6283C),
            borderWidth: 2,
          ),
          SizedBox( height: 20.h,),
          ButtonWidget(
              label: "Delete Account",
            buttonHeight: 45,
            backgroundColor: Color(0xFFE6283C),
            buttonRadius: 12,
          ),
        ],
      ),
    );
  }

  GestureDetector _buildProfileOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          horizontalTitleGap: 12.w,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),

          leading: Icon(icon, color: AppColors.black, size: 26.sp),

          title: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.black,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
