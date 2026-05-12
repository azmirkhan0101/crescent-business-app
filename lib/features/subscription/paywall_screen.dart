import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:organization/routes/app_pages.dart';

import '../../core/subscription_service.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaywallView(
        offering: null, // Loads the default active offering and paywall configured in RC dashboard
        onPurchaseCompleted: (customerInfo, storeTransaction) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.mainNav);
          }
        },
        onRestoreCompleted: (customerInfo) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.mainNav);
            Get.snackbar("Restored!", "Your purchases have been successfully restored.", snackPosition: SnackPosition.TOP);
          } else {
            Get.snackbar("Restore Failed", "No active subscription found for this account.", snackPosition: SnackPosition.BOTTOM);
          }
        },
      ),
    );
  }
}