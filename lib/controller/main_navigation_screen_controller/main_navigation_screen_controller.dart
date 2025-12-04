import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/features/analytics/analytics_screen.dart';
import 'package:organization/features/home/home_screen.dart';
import 'package:organization/features/profile/business_profile_screen.dart';
import 'package:organization/features/redeem_rewards/redeem_scanner_screen.dart';
import 'package:organization/features/reward/edit_reward_screen.dart';
import 'package:organization/features/reward/reward_screens.dart';

import '../../utils/assets_path.dart';

class MainNavigationScreenController extends GetxController{

  RxInt currentIndex = 0.obs;

  final List<Widget> bottomNavScreens = [
    HomeScreen(),
    AnalyticsScreen(),
    RedeemScannerScreen(),
    RewardScreen(),
    BusinessProfileScreen()
  ];

  final List<String> navItemIconPath = [
    AssetsPath.homeIcon,
    AssetsPath.chartIcon,
    AssetsPath.scanQrIcon,
    AssetsPath.starEmphasisIcon,
    AssetsPath.userIcon
  ];
}