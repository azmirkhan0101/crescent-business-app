
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/reward/widget/reward_card_widget.dart';
import 'package:organization/features/reward/widget/row_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

class TabRewardScreen extends StatefulWidget {
  const TabRewardScreen({super.key});

  @override
  State<TabRewardScreen> createState() => _TabRewardScreenState();
}

class _TabRewardScreenState extends State<TabRewardScreen> with SingleTickerProviderStateMixin {







  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal:16.w),
          child: Column(
            children: [
              SizedBox(height: 52.h),
              const CustomRowWidget(),
               SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                child: ButtonsTabBar(
                  // Remove extra padding to let tabs expand
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    unselectedBackgroundColor:Color(0x1A000000),
                    backgroundColor: AppColors.black,
                    unselectedLabelStyle: GoogleFonts.inter(
                      color: AppColors.blackTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400
                    ),
                 //   unselectedLabelStyle: AppTextStyle.mediumStyle.copyWith(color: AppColors.blackTextColor),
                    labelStyle:  GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400
                    ),

                    tabs: [
                      Tab(text: "All",),
                      Tab(text: "Active",),
                      Tab(text: "Disabled",),
                      Tab(text: "Expiring soon",),
                    ]),
              ),

              Expanded(child: TabBarView(children: [
                ListView(
                  children:  [
                    RewardCard(
                      title: 'Free Coffee',
                      assetIcon: AssetsPath.rankBadgeIcon,
                      expiryDate: 'June 30, 2025',
                      redemptions: 120,

                    ),
                    SizedBox(height: 12),
                    RewardCard(
                      title: 'Free Muffin',
                      assetIcon: AssetsPath.rankBadge1Icon,
                      expiryDate: 'June 30, 2025',
                      redemptions: 86,

                    ),
                    SizedBox(height: 12),
                    RewardCard(
                      title: '10% Off Entire Order',
                      assetIcon: AssetsPath.rankBadge2Icon,
                      expiryDate: 'June 30, 2025',
                      redemptions: 86,

                    ),

                  ],
                ),

                Center(child: Text("Active" ),),
                Center(child: Text("Disabled"),),
                Center(child: Text("Expiring soon"),),


              ])),

            ],
          ),
        ),
      ),
    );
  }
}
