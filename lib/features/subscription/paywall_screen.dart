import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/utils/app_color.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:organization/routes/app_pages.dart';

import '../../core/subscription_service.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaywallView(
        displayCloseButton: true,
        onDismiss: (){
          Navigator.of(context).pop();
        },
        offering: null, // Loads the default active offering and paywall configured in RC dashboard
        onPurchaseCompleted: (customerInfo, storeTransaction) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.mainNav);
            showSnackBar(title: "Subscribed!", message: "Your subscription has been successfully completed.", backgroundColor: AppColors.successGreen);
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