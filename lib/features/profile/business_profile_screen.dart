import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/profile/widget/business_profile_image_widget.dart';
import 'package:organization/features/profile/widget/over_view_tabs_widget.dart';
import 'package:organization/features/profile/widget/rewards_tab_widget.dart';

import '../../controller/profile/business_profile_controller.dart';
import '../../core/context_extension.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_text.dart';

class BusinessProfileScreen extends StatelessWidget {
  final BusinessProfileController controller =
  Get.find<BusinessProfileController>();

  BusinessProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTab = context.isTab;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          clipBehavior: Clip.none,
          backgroundColor: AppColors.white,
          elevation: 0,
          title: CustomText(
            text: "Business Profile",
            fontWeight: FontWeight.w700,
            fontSize: isTab ? 16.sp : 20.sp,
            color: AppColors.blackTextColor,
          ),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.profileSettings),
              icon: Icon(Icons.settings, size: isTab ? 32 : null),
            ),
            IconButton(
              onPressed: () {
                controller.setControllerValues();
                Get.toNamed(AppRoutes.editProfile);
              },
              icon: Icon(Icons.edit_outlined, size: isTab ? 32 : null),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.model.value == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return mainBody(context);
          }
        }),
      ),
    );
  }

  Widget mainBody(BuildContext context) {
    bool isTab = context.isTab;
    // Calculate a dynamic horizontal padding for a premium look on wider tablet screens
    double horizontalPadding = isTab ? 32.w : 16.w;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // 1. Top profile headers that scroll on tight heights (like landscape tablet)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  BusinessProfileWidget(
                    coverImageUrl: controller.coverImageUrl.value,
                    logoImageUrl: controller.logoImageUrl.value,
                  ),
                  SizedBox(height: 60.h),
                  Text(
                    controller.model.value!.name,
                    style: AppTextStyle.headlineLStyle.copyWith(fontSize: isTab ? 12.sp : 18.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    controller.model.value!.category,
                    style: AppTextStyle.mediumStyle.copyWith(
                      fontSize: isTab ? 10.sp : 13.sp,
                      color: const Color(0xFF848484),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    controller.model.value!.tagline,
                    style: AppTextStyle.cardTextStyle.copyWith(fontSize: isTab ? 10.sp : 12.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // 2. TabBar pinned or scrolled directly above the TabBarView
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverToBoxAdapter(
              child: TabBar(
                indicatorColor: AppColors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  fontSize: isTab ? 10.sp : 14.sp,
                ),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Rewards'),
                ],
              ),
            ),
          ),

          // 3. The TabBarView occupying the remainder of the viewport safely
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12.h),
            sliver: SliverFillRemaining(
              hasScrollBody: true, // Allows the listviews inside your tabs to scroll independently
              child: TabBarView(
                children: [
                  OverviewTab(model: controller.model.value!),
                  Obx(() {
                    if (controller.rewards.isEmpty) {
                      return Center(
                        child: Text("No rewards found!", style: isTab ? TextStyle(fontSize: 12.sp) : null,),
                      );
                    } else {
                      return RewardsTab(
                        rewards: controller.rewards.value,
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}