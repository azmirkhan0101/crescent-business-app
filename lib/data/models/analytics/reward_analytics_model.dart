import 'graph_data_model.dart';
import 'summary_model.dart';

class RewardAnalyticsModel {
  final SummaryModel summaryModel;
  final List<GraphDataModel> graphDataModel;

  RewardAnalyticsModel({
    required this.summaryModel,
    required this.graphDataModel,
  });

  factory RewardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return RewardAnalyticsModel(
      summaryModel: SummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
      graphDataModel: (json['chartData'] as List)
          .map((e) => GraphDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summaryModel.toJson(),
      'chartData': graphDataModel.map((e) => e.toJson()).toList(),
    };
  }
}
