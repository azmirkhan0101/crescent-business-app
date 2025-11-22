import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/profile/widget/business_profile_image_widget.dart';
import 'package:organization/features/profile/widget/over_view_tabs_widget.dart';
import 'package:organization/features/profile/widget/rewards_tab_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../routes/app_pages.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        clipBehavior: Clip.none,
        backgroundColor: AppColors.white,
        title: CustomText(
          text: "Business Profile",
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: AppColors.blackTextColor,
        ),

        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.editProfile);
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AssetsPath.editIcon,
                  color: AppColors.blackTextColor,
                  width: 16.w,
                  height: 16.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            BusinessProfileWidget(),
            SizedBox(height: 60.h),
            Text(
              'Sweet Whisk Bakery',
              style: AppTextStyle.headlineLStyle.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Business Category',
              style: AppTextStyle.mediumStyle.copyWith(
                fontSize: 13.sp,
                color: Color(0xFF848484),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Whipping Up Smiles, One Treat at a Time!',
              style: AppTextStyle.cardTextStyle.copyWith(fontSize: 12.sp),
            ),
            const SizedBox(height: 16),

            // TabBar
            TabBar(
              indicatorColor: AppColors.black,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
                fontSize: 14.sp,
              ),
              tabs: [
                Tab(child: Text('Overview')),
                Tab(child: Text("Rewards")),
              ],
            ),
            SizedBox(height: 12.h),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [OverviewTab(), RewardsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
