class GraphDataModel {
  final String date;
  final int day;
  final int views;
  final int claims;
  final int redemptions;

  GraphDataModel({
    required this.date,
    required this.day,
    required this.views,
    required this.claims,
    required this.redemptions,
  });

  factory GraphDataModel.fromJson(Map<String, dynamic> json) {
    return GraphDataModel(
      date: json['date'] ?? '',
      day: json['day'] ?? 0,
      views: json['views'] ?? 0,
      claims: json['claims'] ?? 0,
      redemptions: json['redemptions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'views': views,
      'claims': claims,
      'redemptions': redemptions,
    };
  }
}