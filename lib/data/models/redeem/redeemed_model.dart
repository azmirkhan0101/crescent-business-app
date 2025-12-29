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

  factory RedeemedRewardModel.fromJson(Map<String, dynamic> json) {

    return RedeemedRewardModel(
      title: json['rewardTitle'] ?? '',
      image: json['image'] ?? '',
      redeemedCount: json['redemptionCount'] ?? 0,
      redeemedAt: DateTime.parse(json['redeemedAt']).toLocal(),
      redemptionMethod: json['method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rewardTitle': title,
      'image': image,
      'redemptionCount': redeemedCount,
      'redeemedAt': redeemedAt.toUtc().toIso8601String(),
      'method': redemptionMethod,
    };
  }
}
