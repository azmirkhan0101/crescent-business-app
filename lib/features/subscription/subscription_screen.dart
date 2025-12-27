import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:organization/controller/subscription/subscription_controller.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // Selected plan (0 = Free, 1 = 6 Months)
  int selectedPlan = 0;

  final SubscriptionController controller = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Overlay
          _buildBackgroundImage(),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildAppBar(context),
                        SizedBox(height: 15.h),
                        _buildHeaderSection(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    // Allows content to be smaller than the screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // Pushes child to bottom
                      children: [
                        _buildSubscriptionContent(context),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build background image with gradient overlay
  Widget _buildBackgroundImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background-image.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.0),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 0.82, 1.0],
          ),
        ),
      ),
    );
  }

  /// Build app bar with back button and title
  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: AppColors.white,
            ),
          ),

          // Title
          Expanded(
            child: CustomText(
              text: "Subscriptions",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),

          // Space for symmetry
          SizedBox(width: 44.w),
        ],
      ),
    );
  }

  //Build header section with title and description
  Widget _buildHeaderSection() {
    return Column(
      children: [
        CustomText(
          textAlign: TextAlign.center,
          maxLines: 2,
          text: "Start making an effortless impact",
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),

        SizedBox(height: 16.h),

        CustomText(
          maxLines: 2,
          textAlign: TextAlign.center,
          text:
              "Give your way, grow your impact, unlock little wins as you go.",
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
      ],
    );
  }

  /// Build subscription content with features and plans
  Widget _buildSubscriptionContent(BuildContext context) {
    return Column(
      children: [
        // Features Section
        _buildFeaturesSection(),

        SizedBox(height: 20.h),

        // Subscription Plans
        _buildSubscriptionPlans(),

        SizedBox(height: 20.h),

        // Subscribe Button
        _buildSubscribeButton(context),
      ],
    );
  }

  /// Build features section with three feature icons
  Widget _buildFeaturesSection() {
    return Column(
      children: [
        Row(
          children: [
            // Feature 1: Monthly Impact
            Expanded(
              child: _buildFeatureItem(
                icon: "assets/images/Donation.svg",
                backgroundColor: const Color(0xFFE6D4FF),
                title: 'Make an impact monthly, effortlessly',
              ),
            ),

            SizedBox(width: 8.w),

            // Feature 2: Brand Rewards
            Expanded(
              child: _buildFeatureItem(
                icon: "assets/images/exclusive-brand-reward.svg",
                backgroundColor: const Color(0xFFB5E0FF),
                title: 'Unlock exclusive brand rewards',
              ),
            ),

            SizedBox(width: 8.w),

            // Feature 3: Perks & Badges
            Expanded(
              child: _buildFeatureItem(
                icon: "assets/images/star-filled.svg",
                backgroundColor: const Color(0xFFFFE8FD),
                title: 'Get surprise perks & milestone badge',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual feature item
  Widget _buildFeatureItem({
    required String icon,
    required Color backgroundColor,
    required String title,
  }) {
    return Column(
      children: [
        // Icon Container
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFF000C0B),
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Title
        CustomText(
          textAlign: TextAlign.center,
          text: title,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xFFEBE9EC),
        ),
      ],
    );
  }

  /// Build subscription plans section
  Widget _buildSubscriptionPlans() {
    return Row(
      spacing: 8.w,
      children: [
        // Free Plan
        Expanded(
          child: _buildPlanCard(
            planIndex: 0,
            title: 'Monthly',
            price: '\$20.00',
            subtitle: 'Stay on Monthly Plan',
            description: 'Stay on Monthly Plan.',
            isSelected: selectedPlan == 0,
          ),
        ),
        // 6 Months Plan
        Expanded(
          child: _buildPlanCard(
            planIndex: 1,
            title: '6 Months',
            price: '\$120.00',
            description: '',
            features: ['Save 50%.', 'Free 6 month Trial.'],
            isSelected: selectedPlan == 1,
          ),
        ),
      ],
    );
  }

  /// Build individual plan card
  Widget _buildPlanCard({
    required int planIndex,
    required String title,
    required String price,
    String? subtitle,
    required String description,
    List<String>? features,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = planIndex;
        });
      },
      child: Container(
        height: 174.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF000C0B),
          borderRadius: BorderRadius.circular(18.w),
          border: isSelected
              ? Border.all(color: const Color(0xFFD1FF43), width: 2)
              : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    text: price,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                  if (subtitle != null)
                    CustomText(
                      text: subtitle,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                ],
              ),

              // Features or Description
              if (features != null && features.isNotEmpty)
                Column(
                  children: features
                      .map((feature) => _buildFeatureBullet(feature))
                      .toList(),
                )
              else
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFEBE9EC),
                    height: 1.29,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build feature bullet point
  Widget _buildFeatureBullet(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD1FF43),
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                //fontFamily: DonationFonts.interDisplay,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFEBE9EC),
                height: 1.29,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build subscribe button
  Widget _buildSubscribeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Obx(() {
          final bool subscribed = controller.isSubscribed.value;
          //final RxBool subscribed = true.obs;

          return ElevatedButton(
            onPressed: subscribed
                ? () => _handleSubscribe(context) // disables the button
                : () => _handleSubscribe(context),

            style: ElevatedButton.styleFrom(
              backgroundColor: subscribed
                  ? Colors.grey.shade400 // disabled look
                  : const Color(0xFFD1FF43),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
            ),

            child: controller.isSubscribing.value
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF000C0B),
              ),
            )
                : Text(
              subscribed ? 'Subscribed' : 'Subscribe',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: subscribed
                    ? Colors.grey.shade600
                    : const Color(0xFF000C0B),
                letterSpacing: -0.36,
              ),
            ),
          );
        })
      ),
    );
  }

  /// Handle subscribe button press
  void _handleSubscribe(BuildContext context) {
    String plan = selectedPlan == 0 ? "monthly" : "yearly";
    controller.subscribe(plan: plan);
    print("Is subscribed ${controller.isSubscribed.value}");
    //Get.back();
  }
}
