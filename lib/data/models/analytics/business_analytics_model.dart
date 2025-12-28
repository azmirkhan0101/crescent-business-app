import 'redemption_method_model.dart';
import 'top_rewards_model.dart';

class BusinessAnalyticsModel {
  final int totalRedemptions;
  final int profileViews;
  final double profilePercentage;
  final bool profileViewsIncrease;
  final int websiteViews;
  final double websitePercentage;
  final bool websiteViewsIncrease;
  final List<RedemptionMethodModel> methods;
  final List<TopRewardModel> topRewards;

  BusinessAnalyticsModel({
    required this.totalRedemptions,
    required this.profileViews,
    required this.profilePercentage,
    required this.profileViewsIncrease,
    required this.websiteViews,
    required this.websitePercentage,
    required this.websiteViewsIncrease,
    required this.methods,
    required this.topRewards,
  });

  factory BusinessAnalyticsModel.fromJson(Map<String, dynamic> json) {
    var methodsList = json['methods'] as List?;
    List<RedemptionMethodModel> methods = methodsList != null
        ? methodsList.map((i) => RedemptionMethodModel.fromJson(i)).toList()
        : [];

    var topRewardsList = json['topRewards'] as List?;
    List<TopRewardModel> topRewards = topRewardsList != null
        ? topRewardsList.map((i) => TopRewardModel.fromJson(i)).toList()
        : [];

    return BusinessAnalyticsModel(
      totalRedemptions: json['total_redemptions'] as int? ?? 0,
      profileViews: json['profile_views'] as int? ?? 0,
      profilePercentage: (json['profile_percentage'] as num?)?.toDouble() ?? 0.0,
      profileViewsIncrease: json['profile_views_increase'] as bool? ?? false,
      websiteViews: json['website_views'] as int? ?? 0,
      websitePercentage: (json['website_percentage'] as num?)?.toDouble() ?? 0.0,
      websiteViewsIncrease: json['website_views_increase'] as bool? ?? false,
      methods: methods,
      topRewards: topRewards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_redemptions': totalRedemptions,
      'profile_views': profileViews,
      'profile_percentage': profilePercentage,
      'profile_views_increase': profileViewsIncrease,
      'website_views': websiteViews,
      'website_percentage': websitePercentage,
      'website_views_increase': websiteViewsIncrease,
      // Mapping the lists to JSON
      'methods': methods.map((e) => e.toJson()).toList(),
      'topRewards': topRewards.map((e) => e.toJson()).toList(),
    };
  }
}
