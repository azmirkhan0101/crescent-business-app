import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/profile/profile_settings_controller.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/core/subscription_service.dart';
import 'package:organization/features/widgets/button_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/context_extension.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<ProfileSettingsScreen> {

  final ProfileSettingsController controller = Get.find<ProfileSettingsController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: isTab ? 40 : 20.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Profile',
          fontSize: isTab ? 16.sp : 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.blackTextColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ///profile header section
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 16.h),

                  Container(
                    width: isTab ? 150 : 80.w,
                    height: isTab ? 150 : 80.h,
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
                      child: Obx((){
                        return buildProfileImage();
                      })
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Obx((){
                    return CustomText(
                      text: controller.businessName.value,
                      fontSize: isTab ? 16.sp : 24.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000C0B),
                    );
                  }),

                  SizedBox(height: 4.h),

                  Obx((){
                    return CustomText(
                      text: controller.businessEmail.value,
                      fontSize: isTab ? 14.sp : 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    );
                  }),
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
                    isTab: isTab
                  ),

                  _buildProfileOption(
                    title: "Change Password",
                    icon: Icons.lock_outline,
                    onTap: () {
                      Get.toNamed(AppRoutes.changePassword);
                    },
                      isTab: isTab
                  ),
                  _buildProfileOption(
                    title: " Manage Subscriptions",
                    icon: Icons.subscriptions_outlined,
                    onTap: () {
                      Get.toNamed(AppRoutes.manageSubscriptionScreen);
                    },
                      isTab: isTab
                  ),
                  _buildProfileOption(
                    title: "Terms & Conditions",
                    icon: Icons.info_outline,
                    onTap: () {
                      Get.toNamed(AppRoutes.termsCondition);
                    },
                      isTab: isTab
                  ),
                ],
              ),
            ),

            ///button
            SizedBox(height: 24.h),
            ButtonWidget(
              label: "Logout",
            buttonHeight: isTab ? 50 : 45,
            textColor: Color(0xFFE6283C),
              buttonRadius: 12,
              fontSize: isTab ? 10 : 16,
              backgroundColor: Color(0xFFFFE6E6),
              borderColor: Color(0xFFE6283C),
              borderWidth: 2,
              onPressed: (){
                showLogoutDialog();
              },
            ),
            SizedBox( height: 20.h,),
            ButtonWidget(
                label: "Delete Account",
              buttonHeight: isTab ? 50 : 45,
              backgroundColor: Color(0xFFE6283C),
              buttonRadius: 12,
              fontSize: isTab ? 10 : 16,
              onPressed: (){
                  showDeleteDialog();
              },
            ),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }


  //LOGOUT ALERT
  void showLogoutDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: AppColors.red,),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                 SizedBox(width: 12.w), // Spacing between buttons

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.logOut();
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //DELETE ALERT
  void showDeleteDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete, color: AppColors.red,),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete your account?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                 SizedBox(width: 12.w), // Spacing between buttons

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.deleteAccount();
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  GestureDetector _buildProfileOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isTab
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

          leading: Icon(icon, color: AppColors.black, size: isTab ? 40 : 26.sp),

          title: Text(
            title,
            style: TextStyle(fontSize: isTab ? 10.sp : 16.sp, fontWeight: FontWeight.w500),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.black,
            size: isTab ? 40 : 18.sp,
          ),
        ),
      ),
    );
  }


  //BUILD PROFILE IMAGE
  Widget buildProfileImage() {
    if ( controller.logoImageUrl.value.isNotEmpty ) {
      return CachedNetworkImage(
          imageUrl: controller.logoImageUrl.value,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (context, url, error) => Icon(Icons.business, size: 40.r,)
      );
    }
    return Icon(Icons.business, color: Colors.grey, size: 40.r,);
  }
}
