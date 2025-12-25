class RedeemedRewardModel {
  final String title;
  final DateTime redeemedAt;
  final String image;
  final int redeemedCount;
  final String redemptionMethod;

  RedeemedRewardModel({
    required this.title,
    required this.redeemedAt,
    required this.image,
    required this.redeemedCount,
    required this.redemptionMethod,
  });

  /// From JSON
  factory RedeemedRewardModel.fromJson(Map<String, dynamic> json) {
    final reward = json['reward'] ?? {};

    return RedeemedRewardModel(
      title: reward['title'] ?? '',
      image: reward['image'] ?? '',
      redeemedCount: reward['redeemedCount'] ?? 0,
      redeemedAt: DateTime.parse(json['redeemedAt']),
      redemptionMethod: json['redemptionMethod'] ?? '',
    );
  }

  /// To JSON (only selected fields)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'redeemedCount': redeemedCount,
      'redeemedAt': redeemedAt.toIso8601String(),
      'redemptionMethod': redemptionMethod,
    };
  }
}
