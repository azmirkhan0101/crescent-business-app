import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/widgets/button_widget.dart';
import 'package:organization/routes/app_pages.dart';

import '../../core/subscription_service.dart';

class ManageSubscriptionScreen extends StatefulWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  State<ManageSubscriptionScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<ManageSubscriptionScreen> {
  // Track selected plan: 'yearly' or 'monthly'
  String _selectedPlan = 'monthly';
  bool isSubscribed = true;

  @override
  void initState() {

    if( SubscriptionService.to.isBackendPremium.value ){
      isSubscribed = true;
    }else{
      isSubscribed = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: const Color(0XFFF5F7FB), // Soft premium light background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar with Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // App Icon / Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/business_app_icon.png'), // Replace with your asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Unlock full access',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Features Carousel / Benefit Card
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildFeatureCard(
                      title: 'Access all features',
                      subtitle: '• Access to all premium features without limits',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- SUBSCRIPTION OPTIONS ---

              // 1. Yearly Plan (Best Value)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildPlanCard(
                    id: 'yearly',
                    title: 'Yearly',
                    subtitle: '\$10.00/mo billed annually',
                    price: '\$120.00/yr',
                  ),
                  Positioned(
                    top: -12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E7F4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BEST VALUE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey[700],
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Monthly Plan
              _buildPlanCard(
                id: 'monthly',
                title: 'Monthly',
                subtitle: '\$20.00/mo',
                price: '\$20.00/mo',
              ),
              const SizedBox(height: 32),
              Center(
                child:
                Text(
                  "Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Manage or cancel in your device’s Settings.",
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isTab ? 10.sp : 13),
                ),
              ),
              const SizedBox(height: 12),
              if( isSubscribed )
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF40A040),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text("You are currently subscribed", style: TextStyle(fontSize: isTab ? 10.sp : 14, color: Colors.white),),
                ),
              ),
              const SizedBox(height: 12),
              // Subscribe Button
              Center(
                child: ButtonWidget(
                    label: isSubscribed ? "Subscribed" : "Subscribe",
                  buttonHeight: 50,
                  backgroundColor: isSubscribed ? const Color(0xFFABABAB) : const Color(0xFFB062D6), // Vibrant purple
                  onPressed: (){
                      if( isSubscribed ){
                        return;
                      }
                      Get.toNamed(AppRoutes.paywallScreen);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Footer Legal Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFooterLink('Restore Purchase', () {
                    SubscriptionService.to.restorePurchase(context);
                  }),
                  _buildFooterDivider(),
                  _buildFooterLink('Privacy Policy', () {
                    Get.toNamed(AppRoutes.privacyPolicy);
                  }),
                  _buildFooterDivider(),
                  _buildFooterLink('Terms & Conditions', () {
                    Get.toNamed(AppRoutes.termsCondition);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for the feature/benefit card
  Widget _buildFeatureCard({required String title, required String subtitle}) {
    bool isTab = context.isTab;
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTab ? 10.sp : 16),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: isTab ? 10.sp : 13),
          ),
        ],
      ),
    );
  }

  // Helper builder for subscription plan rows
  Widget _buildPlanCard({
    required String id,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final isSelected = _selectedPlan == id;
    bool isTab = context.isTab;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A6CE4) : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTab ? 10.sp : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isTab ? 10.sp : 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: isTab ? 10.sp : 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String label, VoidCallback onTap) {
    bool isTab = context.isTab;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: isTab ? 10.sp : 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '|',
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
    );
  }
}