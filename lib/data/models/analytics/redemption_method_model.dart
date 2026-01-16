class RedemptionMethodModel {
  final String method;
  final int count;
  final double percentage;

  RedemptionMethodModel({
    required this.method,
    required this.count,
    required this.percentage,
  });

  factory RedemptionMethodModel.fromJson(Map<String, dynamic> json) {
    return RedemptionMethodModel(
      method: json['method'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'count': count,
      'percentage': percentage,
    };
  }
}
