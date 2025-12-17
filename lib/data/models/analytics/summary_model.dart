class SummaryModel {
  final int views;
  final int claims;
  final int redemptions;

  SummaryModel({
    required this.views,
    required this.claims,
    required this.redemptions,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      views: json['views'] ?? 0,
      claims: json['claims'] ?? 0,
      redemptions: json['redemptions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'views': views,
      'claims': claims,
      'redemptions': redemptions,
    };
  }
}
