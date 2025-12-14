import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/home/home_controller.dart';
import 'package:organization/features/home/widget/activity_list_tile_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

import '../../data/models/home/recent_activity_model.dart';

class RecentActivities extends StatelessWidget {

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: "Recent Activities",
        fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: RefreshIndicator(
          onRefresh: () async{
            controller.getRecentActivity();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///recent activity list
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Obx(() {
                        if (controller.isRecentActivityLoading.value) {
                          //LOADING
                          return Center(child: CircularProgressIndicator());
                        } else if (!controller.isRecentActivityLoading.value &&
                            controller.recentActivities.isEmpty) {
                          //NO DATA
                          return Center(
                            child: Text("No recent activities found."),
                          );
                        } else {
                          return recentActivityList(recentActivities: controller.recentActivities);
                        }
                      }),
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  //RECENT ACTIVITY LIST - LIMITED TO 5 ITEMS IN HOME SCREEN
  recentActivityList({
    required List<RecentActivityModel> recentActivities,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: recentActivities.length,
      itemBuilder: (context, mainListIndex) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //DATE - TODAY
            CustomText(
              text: recentActivities[mainListIndex].title,
              language: false,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            //DATE WISE ACTIVITIES LIST
            ListView.separated(
              itemCount: recentActivities[mainListIndex].activityItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, subListIndex) {

                return ActivityListTileWidget(
                  item: recentActivities[mainListIndex].activityItems[subListIndex],
                  maxLines: 4,
                );
              },
              separatorBuilder: (context, separatorIndex) => SizedBox(height: 8.h),
            ),
          ],
        );
      },
    );
  }
}
