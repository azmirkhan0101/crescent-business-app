import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/analytics/widget/analytics_card_widget.dart';
import 'package:organization/features/analytics/widget/analytics_chart_widget.dart';
import 'package:organization/features/analytics/widget/analytics_data_class.dart';
import 'package:organization/features/analytics/widget/analytics_header_widget.dart';
import 'package:organization/features/analytics/widget/bottom_sheet_widget.dart';
import 'package:organization/features/analytics/widget/redemption_card_chart_widget.dart';
import 'package:organization/features/analytics/widget/reward_list_item_widget.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../utils/assets_path.dart';

import 'data/models/analytics_card_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {


  void _openBottomSheet() {


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => BottomSheetWidget(),
    );
  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsHeader(),
              SizedBox(height: 16.h),



              /// baki content...
              const RedemptionChartWidget(),
              SizedBox(height: 16.h),
              SizedBox(
                height: 380.h,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: StatsModel.sampleList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.h,
                  ),
                  itemBuilder: (context, index) {
                    final item = analyticsData[index];
                    return AnalyticsCardWidget(
                      topIcon: item["topIcon"]!,
                      bottomIcon: item["bottomIcon"]!,
                      title: item["title"]!,
                      subtitle: item["subtitle"]!,
                      bottomText: item["bottomText"]!,
                      bottomEndText: item["bottomEndText"]!,
                    );
                  },
                ),
              ),
              const AnalyticsCardChart(),
              SizedBox(height: 16.h),
              CustomCard(
                height: 197.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomAssetsImage(
                          assetsPath: AssetsPath.rocketIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(text:  "Top Rewards",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: AppColors.blackTextColor,
                        ),


                      ],
                    ),
                    RewardListItem(
                      rewardText: '10% Off Latte',
                      percentage: 40.2,
                      isGrowth: true,
                      assetsIcon: AssetsPath.rankBadgeIcon,
                    ),
                    RewardListItem(
                      rewardText: '10% Off Latte',
                      percentage: 40.2,
                      isGrowth: true,
                      assetsIcon: AssetsPath.rankBadge1Icon,
                    ),
                    RewardListItem(
                      rewardText: '10% Off Latte',
                      percentage: 40.2,
                      isGrowth: true,
                      assetsIcon: AssetsPath.rankBadge2Icon,
                    ),
                  ],
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: (){
                    _openBottomSheet();
                  },
                  child: const Text("Open Bottom Sheet"),
                ),
              ),

            ],
          ),
        ),


      ),
    );

  }
}


