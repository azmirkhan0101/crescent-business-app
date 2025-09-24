import 'package:flutter/material.dart';
import 'package:organization/utils/assets_path.dart';

/// Model
class ActivityItem {
  final String icon;
  final Color iconColor;
  final String text;
  final String timestamp;

  ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.timestamp,
  });
}

/// Dummy Data
final List<ActivityItem> activityItems = [
  ActivityItem(
    icon:AssetsPath.activity1Icon,
    iconColor: Colors.redAccent,
    text: 'John D. redeemed "10% Off Latte" via QR.',
    timestamp: '2 min ago',
  ),
  ActivityItem(
    icon:AssetsPath.activity2Icon,
    iconColor: Colors.redAccent,
    text: 'Sarah K. redeemed "Free Muffin" via NFC.',
    timestamp: '5 min ago',
  ),
  ActivityItem(
    icon:AssetsPath.activity3Icon,
    iconColor: Colors.green,
    text: 'New Reward Published: "Buy 1 Get 1 Free"',
    timestamp: '1 hour ago',
  ),
  ActivityItem(
    icon:AssetsPath.activity4Icon,
    iconColor: Colors.redAccent,
    text: 'Maria S. redeemed "10% Off Latte" via QR...',
    timestamp: '2 hours ago',
  ),
];
