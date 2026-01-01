import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/controller/profile/profile_settings_controller.dart';
import 'package:organization/features/profile/widget/notification_card.dart';


class NotificationScreen extends StatelessWidget {

  final ProfileSettingsController controller = Get.find<ProfileSettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          NotificationCard(
            title: "Push Notifications",
            subtitle: "Manage what updates you want to hear about from Crescent Change.",
            svgIconPath: "assets/images/Donation.svg",
            isEnabled: controller.isPushNotificationEnabled,
            onChanged: (bool value) {
              controller.isPushNotificationEnabled = value;
              controller.changeNotificationSettings();
            },
          ),
          NotificationCard(
            title: "Donation Updates",
            subtitle: "Get notified when your donation is sent or when a recurring one is coming up.",
            svgIconPath: "assets/images/exclusive-brand-reward.svg",
            isEnabled: controller.isDonationUpdatesEnabled,
            onChanged: (bool value) {
              controller.isDonationUpdatesEnabled = value;
              controller.changeNotificationSettings();
            },
          ),
          NotificationCard(
            title: "Rewards & Perks",
            subtitle: "We’ll ping you when you earn rewards, perks, or kindness streaks!",
            svgIconPath: "assets/images/star-filled.svg",
            isEnabled: controller.isRewardPerksEnabled,
            onChanged: (bool value) {
              controller.isRewardPerksEnabled = value;
              controller.changeNotificationSettings();
            },
          ),
        ],
      ),
    );
  }
}
