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
    required this.topRewards
  });

  factory BusinessAnalyticsModel.fromJson(Map<String, dynamic> json){
    return BusinessAnalyticsModel(
        totalRedemptions: json['totalRedemptions'] ?? 0,
        profileViews: json['profileCurrent'] ?? 0,
        profilePercentage: json['profileChange'] ?? 0,
        profileViewsIncrease: json['profileIncrease'] ?? false,
        websiteViews: json['websiteCurrent'] ?? 0,
        websitePercentage: json['websiteChange'] ?? 0,
        websiteViewsIncrease: json['websiteIncrease'] ?? false,
        methods: (json['methods'] as List).map((e){
          return RedemptionMethodModel.fromJson(e);
        }).toList(),
        topRewards: (json['topRewards'] as List<dynamic>? ?? []).map((e){
          return TopRewardModel.fromJson(e);
        }).toList()
    );
  }
}

