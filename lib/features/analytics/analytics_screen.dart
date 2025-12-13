import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

import '../../utils/app_size.dart';
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
        backgroundColor: const Color(0xFFF7F7F7),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

             ///header section
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
                          child: DropdownButton<String>(
                            value: 'Last 7 Days',
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackTextColor,
                                fontSize: 14.sp
                            ),

                            onChanged: (String? newValue) {
                              // Handle dropdown change
                            },
                            items: <String>['Last 7 Days', 'Last 30 Days', 'This Month', 'Last Month']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: (){
                     _openBottomSheet();
                            },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:const Color(0x199E9E9E),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            AssetsPath.export,
                            height: 10.h,
                            width: 10.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),




              SizedBox(height: 16.h),



              /// baki content...
              const RedemptionChartWidget(),
              SizedBox(height: 16.h),
              ///card
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
                      title: item["title"]!,
                      subtitle: item["subtitle"]!,
                      bottomText: item["bottomText"]!,
                      bottomEndText: item["bottomEndText"]!,
                      isIncrease: false,
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
                      assetsIcon: AssetsPath.rewardDiscountIcon,
                    ),
                    RewardListItem(
                      rewardText: '10% Off Latte',
                      percentage: 40.2,
                      isGrowth: true,
                      assetsIcon: AssetsPath.rewardDiscountIcon,
                    ),
                    RewardListItem(
                      rewardText: '10% Off Latte',
                      percentage: 40.2,
                      isGrowth: true,
                      assetsIcon: AssetsPath.rewardDiscountIcon,
                    ),
                  ],
                ),
              ),
              SizedBox( height: 90.h,)

            ],
          ),
        ),


      ),
    );

  }
}


