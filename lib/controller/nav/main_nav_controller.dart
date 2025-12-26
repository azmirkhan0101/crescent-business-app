import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/features/analytics/analytics_screen.dart';
import 'package:organization/features/home/home_screen.dart';
import 'package:organization/features/profile/business_profile_screen.dart';
import 'package:organization/features/redeem_rewards/redeem_scanner_screen.dart';
import 'package:organization/features/reward/reward_screen.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

class MainNavController extends GetxController{

  RxInt currentIndex = 0.obs;

  final List<Widget> bottomNavScreens = [
    HomeScreen(),
    AnalyticsScreen(),
    RedeemScannerScreen(),
    RewardScreen(),
    BusinessProfileScreen()
  ];

  final List<String> navItemIconPath = [
    Assets.icons.navHome,
    Assets.icons.navAnalytics,
    Assets.icons.scanQrCode,
    Assets.icons.navRewards,
    Assets.icons.account
  ];
}