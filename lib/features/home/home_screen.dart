import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/home/home_controller.dart';
import 'package:organization/features/home/widget/activity_list_tile_widget.dart';
import 'package:organization/features/home/data/models/activity_data_class.dart';
import 'package:organization/features/home/widget/bar_chart_widget.dart';
import 'package:organization/features/home/widget/home_card_widget.dart';
import 'package:organization/features/home/widget/home_header_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text_styles.dart';
import '../analytics/widget/analytics_card_widget.dart';

class HomeScreen extends StatelessWidget {

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: GET NAME AND LOGO URL FROM STORAGE, WE GET THEM FROM GETPROFILE API AFTER LOGIN-SIGNUP
                /// header profile
                HomeHeaderWidget(userName: 'Talha S.'),
                //TODO: DEBUG BUTTON, REMOVE LATER
                ElevatedButton(onPressed: (){
                  controller.getBusinessOverview();
                }, child: Text("debug")),
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
                      child: Obx((){
                        return AnalyticsCardWidget(
                          topIconColor: Color(0xFFC08FFF),
                          topIcon: AssetsPath.scanQrIcon,
                          title: 'Redemptions',
                          subtitle: 'Last 7 days',
                          bottomText: controller.homeStatModel.value?.overview.lastSevenDaysRedeemed.toString() ?? "0",
                          bottomEndText: "${controller.homeStatModel.value?.overview.sevenDaysGrowthPercentage ?? 0} %",
                          isIncrease: controller.homeStatModel.value?.overview.isIncrease ?? true,
                        );
                      })
                    ),
                    Expanded(
                      child: HomeCardWidget(
                        topIcon: AssetsPath.starEmphasisIcon,
                        title: 'Active Rewards',
                        bottomText: controller.homeStatModel.value?.overview.totalActiveRewards.toString() ?? "0",
                      ),
                    ),
                  ],
                ),

                //bar chart
                HomeBarChartWidget(),

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
                      onPressed: () {},
                      child: CustomText(text:  "View All",
                      fontWeight: FontWeight.w400,color: AppColors.primaryColor,language: false,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Today",
                          language: false,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextColor,
                        ),

                        SizedBox(height: 8.h),
                        ListView.separated(
                          itemCount: activityItems.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ActivityListTileWidget(
                              item: activityItems[index],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
