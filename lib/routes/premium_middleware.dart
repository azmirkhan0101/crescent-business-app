import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/routes/app_pages.dart';

import '../core/subscription_service.dart';

class PremiumMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!SubscriptionService.to.hasPremium) {
      // User does not have backend premium NOR RevenueCat premium.
      // Redirect them to the RevenueCat paywall.
      return RouteSettings(name: AppRoutes.paywallScreen);
    }
    return null; // Has premium, allow access
  }
}