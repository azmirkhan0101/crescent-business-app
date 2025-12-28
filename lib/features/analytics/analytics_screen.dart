import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/analytics/analytics_controller.dart';
import 'package:organization/features/analytics/widget/analytics_card_widget.dart';
import 'package:organization/features/analytics/widget/analytics_chart_widget.dart';
import 'package:organization/features/analytics/widget/bottom_sheet_widget.dart';
import 'package:organization/features/analytics/widget/redemption_card_chart_widget.dart';
import 'package:organization/features/analytics/widget/reward_list_item_widget.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../utils/assets_path.dart';

class AnalyticsScreen extends StatelessWidget {

  final AnalyticsController controller = Get.find<AnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color(0xFFF7F7F7),
        body: RefreshIndicator(
          onRefresh: () async{
            await controller.getBusinessAnalytics();
            if( controller.rewardIds.isNotEmpty ){
              await controller.getRewardAnalyticsById(rewardId: controller.rewardIds[controller.rewardTitles.indexOf(controller.selectedTitle.value)]);
            }

          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                //====================HEADER - APPBAR========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Analytics',
                      style: GoogleFonts.familjenGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.headlineTColor,
                      ),
                    ),
                    //TIME FILTER DROPDOWN
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x199E9E9E),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                              child: Obx((){
                                return DropdownButton<String>(
                                  value: controller.selectedTimeline.value,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackTextColor,
                                    fontSize: 14.sp,
                                  ),
                                  onChanged: (String? newValue) {
                                    controller.updateFilterTimeLine(  newValue );
                                    controller.getBusinessAnalytics();
                                  },
                                  items:
                                  controller.timeLines.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                );
                              })
                          )
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                            onPressed: (){
                              openBottomSheet(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(AppColors.white),
                                elevation: WidgetStatePropertyAll(4), shadowColor: WidgetStatePropertyAll(Color(0x199E9E9E))),
                            icon: Icon(Icons.upload, size: 20, color: AppColors.black,)
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                //REDEMPTION PIE CHART SECTION
                Obx((){
                  return RedemptionChartWidget(
                    totalRedemptions: controller.businessAnalyticsModel.value?.totalRedemptions ?? 0,
                    methods: controller.methods,
                  );
                }),
                SizedBox(height: 16.h),
                //===============WEBSITE VISIT - PROFILE VIEW================
                Row(
                  spacing: 5.w,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx((){
                        //WEBSITE VISITS
                        return AnalyticsCardWidget(
                            isProfileViewsCard: false,
                            timeLine: controller.selectedTimeline.value,
                            count: controller.businessAnalyticsModel.value?.websiteViews ?? 0,
                            percentage: controller.businessAnalyticsModel.value?.websitePercentage ?? 0.0,
                            isIncrease: controller.businessAnalyticsModel.value?.websiteViewsIncrease ?? false
                        );
                      }),
                    ),
                    Expanded(
                      child: Obx((){
                        //PROFILE VIEWS
                        return AnalyticsCardWidget(
                            isProfileViewsCard: true,
                            timeLine: controller.selectedTimeline.value,
                            count: controller.businessAnalyticsModel.value?.profileViews ?? 0,
                            percentage: controller.businessAnalyticsModel.value?.profilePercentage ?? 0.0,
                            isIncrease: controller.businessAnalyticsModel.value?.profileViewsIncrease ?? false
                        );
                      }),
                    )
                  ],
                ),
                //========================REWARD ANALYTICS GRAPH===========================
                Obx((){
                  return AnalyticsCardChart(
                    items: controller.rewardTitles.value,
                    selectedTitle: controller.selectedTitle.value,
                    onItemSelected: ( String selectedValue ) {
                      controller.selectedTitle.value = selectedValue;
                      controller.getRewardAnalyticsById(rewardId: controller.rewardIds[controller.rewardTitles.indexOf(selectedValue)]);
                    },
                    summaryModel: controller.summeryModel.value,
                    graphList: controller.graphs.value,
                  );
                }),
                SizedBox(height: 16.h),
                //================TOP REWARDS SECTION====================
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.icons.topRewards,
                            height: 24.h,
                            width: 24.w,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: "Top Rewards",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.blackTextColor,
                          ),
                        ],
                      ),
                      Obx((){
                        if( controller.isTopRewardsLoading.value ){
                          return Center(child: CircularProgressIndicator(),);
                        }else if( !controller.isTopRewardsLoading.value && controller.topRewards.isEmpty ){
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric( vertical: 15.h),
                              child: Text( "No top rewards found", style: TextStyle(color: AppColors.black),),
                            ),
                          );
                        }else{
                          return topRewardList( context );
                        }
                      }),
                    ],
                  )
                ),
                SizedBox(height: 90.h),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //TOP REWARD LIST
  topRewardList(BuildContext context){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.topRewards.length,
        itemBuilder: (context, index){
          return RewardListItem(
            rewardText: controller.topRewards[index].title,
            percentage: controller.topRewards[index].percentage,
            isGrowth: true,
            assetsIcon: AssetsPath.rewardDiscountIcon,
          );
    });
  }

  //BOTTOM SHEET - EXPORT CSV - PDF
  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => BottomSheetWidget(onExportClick: (bool isPdf) {
        if( isPdf ){
          controller.exportToPdf( controller.businessAnalyticsModel.value );
        }else{
          controller.exportToCsv( controller.businessAnalyticsModel.value );
        }
        Get.back();
      },),
    );
  }
}

