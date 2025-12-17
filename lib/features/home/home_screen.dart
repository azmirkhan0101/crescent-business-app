import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/home/home_controller.dart';
import 'package:organization/data/models/home/recent_activity_item_model.dart';
import 'package:organization/data/models/home/recent_activity_model.dart';
import 'package:organization/features/home/widget/activity_list_tile_widget.dart';
import 'package:organization/features/home/data/models/activity_data_class.dart';
import 'package:organization/features/home/widget/bar_chart_widget.dart';
import 'package:organization/features/home/widget/home_analytics_card.dart';
import 'package:organization/features/home/widget/home_card_widget.dart';
import 'package:organization/features/home/widget/home_header_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/assets_path.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text_styles.dart';
import '../analytics/widget/analytics_card_widget.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final maxRecentItemCount = 5;
  late int recentItemCount;

  @override
  Widget build(BuildContext context) {

    recentItemCount = 0;

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
                    );
                  }),
                  //TODO: DEBUG BUTTON, REMOVE LATER
                  ElevatedButton(
                    onPressed: () {
                      print("Logooooooo: ${controller.profileImageUrl.value}");
                      //controller.profileImageUrl.value = controller.storage.re
                      //controller.profileImageUrl.value = "https://images.unsplash.com/photo-1701615004837-40d8573b6652?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHVzZXJ8ZW58MHx8MHx8fDA%3D";
                      print("Active reward: ${controller.homeStatModel.value?.overview.totalActiveRewards}");
                      //controller.getBusinessOverview();
                      //controller.getRecentActivity();
                    },
                    child: Text("debug"),
                  ),
                  Text(
                    "Overview",
                    style: GoogleFonts.familjenGrotesk(
                      color: AppColors.blackTextColor,
                      fontSize: 20.sp,
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
                            percentage: controller.homeStatModel.value?.overview.sevenDaysGrowthPercentage.toDouble() ?? 0.0,
                          );
                        }),
                      ),
                      Expanded(
                        child: Obx((){
                          return HomeCardWidget(
                            topIcon: AssetsPath.starEmphasisIcon,
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
                          fontSize: 20.sp,
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
                          fontSize: 14.sp,
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
