import 'monthly_stats.dart';

class HomeStatsModel {
  final Overview overview;
  final List<MonthlyStats> monthlyStats;
  final OverallProgress overallProgress;

  HomeStatsModel({
    required this.overview,
    required this.monthlyStats,
    required this.overallProgress,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      overview: Overview.fromJson(json['overview']),
      monthlyStats: (json['monthlyStats'] as List)
          .map((e) => MonthlyStats.fromJson(e))
          .toList(),
      overallProgress: OverallProgress.fromJson(json['overallProgress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overview': overview.toJson(),
      'monthlyStats': monthlyStats.map((e) => e.toJson()).toList(),
      'overallProgress': overallProgress.toJson(),
    };
  }
}

// ---------------------- Overview ----------------------

class Overview {
  final int totalActiveRewards;
  final int lastSevenDaysRedeemed;
  final int previousSevenDaysRedeemed;
  final int sevenDaysGrowthPercentage;
  final bool isIncrease;

  Overview({
    required this.totalActiveRewards,
    required this.lastSevenDaysRedeemed,
    required this.previousSevenDaysRedeemed,
    required this.sevenDaysGrowthPercentage,
    required this.isIncrease,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      totalActiveRewards: json['totalActiveRewards'] ?? 0,
      lastSevenDaysRedeemed: json['lastSevenDaysRedeemed'] ?? 0,
      previousSevenDaysRedeemed: json['previousSevenDaysRedeemed'] ?? 0,
      sevenDaysGrowthPercentage: json['sevenDaysGrowthPercentage'] ?? 0,
      isIncrease: json['isIncrease'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalActiveRewards': totalActiveRewards,
      'lastSevenDaysRedeemed': lastSevenDaysRedeemed,
      'previousSevenDaysRedeemed': previousSevenDaysRedeemed,
      'sevenDaysGrowthPercentage': sevenDaysGrowthPercentage,
      'isIncrease': isIncrease,
    };
  }
}

// ---------------------- Monthly Stats ----------------------

// ---------------------- Overall Progress ----------------------

class OverallProgress {
  final int totalRedemptionLimit;
  final int totalRedeemedCount;
  final double percentage;

  OverallProgress({
    required this.totalRedemptionLimit,
    required this.totalRedeemedCount,
    required this.percentage,
  });

  factory OverallProgress.fromJson(Map<String, dynamic> json) {
    return OverallProgress(
      totalRedemptionLimit: json['totalRedemptionLimit'] ?? 0,
      totalRedeemedCount: json['totalRedeemedCount'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRedemptionLimit': totalRedemptionLimit,
      'totalRedeemedCount': totalRedeemedCount,
      'percentage': percentage,
    };
  }
}
