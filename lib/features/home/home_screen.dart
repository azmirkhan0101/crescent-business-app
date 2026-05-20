import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/home/home_controller.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/data/models/home/recent_activity_model.dart';
import 'package:organization/features/home/widget/activity_list_tile_widget.dart';
import 'package:organization/features/home/widget/bar_chart_widget.dart';
import 'package:organization/features/home/widget/home_analytics_card.dart';
import 'package:organization/features/home/widget/home_card_widget.dart';
import 'package:organization/features/home/widget/home_header_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../utils/app_color.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final maxRecentItemCount = 5;
  late int recentItemCount;

  @override
  Widget build(BuildContext context) {

    recentItemCount = 0;
    bool isTab = context.isTab;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: RefreshIndicator(
          onRefresh: () async{
            controller.getBusinessOverview();
            controller.getRecentActivity();
            controller.getProfileData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header profile
                  Obx((){
                    return HomeHeaderWidget(
                      userName: controller.userName.value,
                      profileImageUrl: controller.profileImageUrl.value,
                      isTab: isTab,
                    );
                  }),
                  Text(
                    "Overview",
                    style: GoogleFonts.familjenGrotesk(
                      color: AppColors.blackTextColor,
                      fontSize: isTab ? 12.sp : 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //OVERVIEW
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                        child: Obx(() {
                          return HomeAnalyticsCard(
                            isIncrease:
                                controller
                                    .homeStatModel
                                    .value
                                    ?.overview
                                    .isIncrease ??
                                false,
                            timeLine: "Last 7 days",
                            count: controller
                                .homeStatModel
                                .value
                                ?.overview
                                .lastSevenDaysRedeemed ??
                                0,
                            percentage: controller.homeStatModel.value?.overview.sevenDaysGrowthPercentage.toDouble() ?? 0.0, isTab: isTab,
                          );
                        }),
                      ),
                      Expanded(
                        child: Obx((){
                          return HomeCardWidget(
                            isTab: isTab,
                            topIcon: Assets.icons.activeRewards,
                            title: 'Active Rewards',
                            bottomText:
                            controller
                                .homeStatModel
                                .value
                                ?.overview
                                .totalActiveRewards
                                .toString() ??
                                "0",
                          );
                        })
                      ),
                    ],
                  ),

                  //bar chart
                  Obx(() {
                    return HomeBarChartWidget(
                      isTab: isTab,
                      stats: controller.monthlyStats,
                      activityPercentage:
                          controller
                              .homeStatModel
                              .value
                              ?.overallProgress
                              .percentage ??
                          0,
                    );
                  }),

                  ///recent activity - view all
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Activity",
                        style: GoogleFonts.familjenGrotesk(
                          color: AppColors.blackTextColor,
                          fontSize: isTab ? 12.sp : 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.recentActivities);
                        },
                        child: CustomText(
                          text: "View All",
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                          language: false,
                          fontSize: isTab ? 10.sp : 14.sp,
                        ),
                      ),
                    ],
                  ),

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
                      padding: EdgeInsets.all( isTab ? 20 : 12.w),
                      child: Obx(() {
                        if (controller.isRecentActivityLoading.value) {
                          //LOADING
                          return Center(child: CircularProgressIndicator());
                        } else if (!controller.isRecentActivityLoading.value &&
                            controller.recentActivities.isEmpty) {
                          //NO DATA
                          return Center(
                            child: Text("No recent activities found." , style: TextStyle(fontSize: isTab ? 8.sp : null)),
                          );
                        } else {
                          recentItemCount = 0;
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
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentActivities.length,
      itemBuilder: (context, mainListIndex) {

        if( recentItemCount > maxRecentItemCount ){//LIMIT ITEMS TO 5
          return SizedBox.shrink();
        }
        recentItemCount++;

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

                if( recentItemCount > maxRecentItemCount ){//LIMIT ITEMS TO 5
                  return SizedBox.shrink();
                }
                recentItemCount++;

                return ActivityListTileWidget(
                  item: recentActivities[mainListIndex].activityItems[subListIndex],
                  maxLines: 1,
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
