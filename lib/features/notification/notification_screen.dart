import 'package:flutter/material.dart';
import 'package:organization/features/notification/widgets/notification_card.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
        children: const [
          NotificationCard(
            title: "Push Notifications",
            subtitle: "Manage what updates you want to hear about from Crescent Change.",
            svgIconPath: "assets/images/Donation.svg",
            initialValue: true,
          ),
          NotificationCard(
            title: "Donation Updates",
            subtitle: "Get notified when your donation is sent or when a recurring one is coming up.",
            svgIconPath: "assets/images/exclusive-brand-reward.svg",
            initialValue: false,
          ),
          NotificationCard(
            title: "Rewards & Perks",
            subtitle: "We’ll ping you when you earn rewards, perks, or kindness streaks!",
            svgIconPath: "assets/images/star-filled.svg",
            initialValue: false,
          ),
        ],
      ),
    );
  }
}
