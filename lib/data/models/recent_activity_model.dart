import 'package:organization/data/models/recent_activity_item_model.dart';

class RecentActivityModel {
  final String title;
  final List<RecentActivityItemModel> activityItems;

  RecentActivityModel({
    required this.title,
    required this.activityItems,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      title: json['title'] ?? '',
      activityItems: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RecentActivityItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'data': activityItems.map((e) => e.toJson()).toList(),
    };
  }
}

