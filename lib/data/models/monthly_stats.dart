class MonthlyStats {
  final String month;
  final int redeemed;
  final int reward;

  MonthlyStats({
    required this.month,
    required this.redeemed,
    required this.reward,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      month: json['month'] ?? '',
      redeemed: json['redeemed'] ?? 0,
      reward: json['reward'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'redeemed': redeemed,
      'reward': reward,
    };
  }
}