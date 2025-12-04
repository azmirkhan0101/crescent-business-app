import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/profile/widget/business_profile_image_widget.dart';
import 'package:organization/features/profile/widget/over_view_tabs_widget.dart';
import 'package:organization/features/profile/widget/rewards_tab_widget.dart';

import '../../controller/profile/business_profile_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/assets_path.dart';
import '../widgets/custom_text.dart';

class BusinessProfileScreen extends StatelessWidget {

  final BusinessProfileController controller = Get.find<BusinessProfileController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              onTap: () => Get.toNamed(AppRoutes.editProfile),
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

        body: Obx((){
          if( controller.model.value == null ){
            return Center( child: CircularProgressIndicator(),);
          }else{
            return mainBody();
          }
        })
      ),
    );
  }

  //MAIN BODY
mainBody(){
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          BusinessProfileWidget(
              coverImageUrl: controller.model.value?.coverImage,
              logoImageUrl: controller.model.value?.logoImage
          ),
          SizedBox(height: 60.h),

          Text(
            controller.model.value!.name,
            style: AppTextStyle.headlineLStyle.copyWith(fontSize: 18.sp),
          ),

          SizedBox(height: 8.h),
          Text(
            controller.model.value!.category,
            style: AppTextStyle.mediumStyle.copyWith(
              fontSize: 13.sp,
              color: Color(0xFF848484),
            ),
          ),

          SizedBox(height: 8.h),
          Text(
            controller.model.value!.tagline,
            style: AppTextStyle.cardTextStyle.copyWith(fontSize: 12.sp),
          ),

          const SizedBox(height: 16),

          // ---------------- TAB BAR ----------------
          TabBar(
            indicatorColor: AppColors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
              fontSize: 14.sp,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Rewards'),
            ],
          ),

          SizedBox(height: 12.h),

          // ---------------- TAB VIEW ----------------
          Expanded(
            child: TabBarView(
              children: [
                OverviewTab(model: controller.model.value!,),
                RewardsTab(),
              ],
            ),
          ),
        ],
      ),
    );
}
}
