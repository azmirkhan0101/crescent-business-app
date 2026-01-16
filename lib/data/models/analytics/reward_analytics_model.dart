import 'graph_data_model.dart';
import 'summary_model.dart';

class RewardAnalyticsModel {
  final SummaryModel summaryModel;
  final List<GraphDataModel> graphDataModels;

  RewardAnalyticsModel({
    required this.summaryModel,
    required this.graphDataModels,
  });

  factory RewardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return RewardAnalyticsModel(
      summaryModel: SummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
      graphDataModels: (json['chartData'] as List)
          .map((e) => GraphDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summaryModel.toJson(),
      'chartData': graphDataModels.map((e) => e.toJson()).toList(),
    };
  }
}
