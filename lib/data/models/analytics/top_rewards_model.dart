class TopRewardModel {
  final String title;
  final double percentage;

  TopRewardModel({required this.title, required this.percentage});

  factory TopRewardModel.fromJson(Map<String, dynamic> json) {
    return TopRewardModel(
      title: json['title'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'percentage': percentage,
    };
  }
}
