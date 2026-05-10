import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/controller/analytics/analytics_exporter.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/analytics/business_analytics_model.dart';
import 'package:organization/data/models/analytics/graph_data_model.dart';
import 'package:organization/data/models/analytics/redemption_method_model.dart';
import 'package:organization/data/models/analytics/reward_analytics_model.dart';
import 'package:organization/data/models/analytics/summary_model.dart';
import 'package:organization/data/models/analytics/top_rewards_model.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/app_color.dart';

import '../../utils/api_endpoints.dart';
import '../../utils/app_constants.dart';
import '../reward/reward_controller.dart';

class AnalyticsController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();

  final RewardController rewardController = Get.find<RewardController>();

  @override
  void onInit() {
    getBusinessAnalytics();
    if( rewardIds.isNotEmpty ){
      getRewardAnalyticsById(rewardId: rewardIds[rewardTitles.indexOf(selectedTitle.value)]);
    }

    ever( rewardController.rewards, (newData) {
      updateRewardTitleList( newData );
    });
    super.onInit();
  }

  //MAKE REWARD TITLE LIST FORM REWARDS LIST
  updateRewardTitleList( List<RewardModel>? rewards ){
    if( rewards == null || rewards.isEmpty ){
      return;
    }
    rewardTitles.value = [];
    rewardIds.value = [];
    for( final model in rewards ){
      rewardTitles.add( model.title );
      rewardIds.add( model.id );
    }
    selectedTitle.value = rewardTitles[0];
  }

  final storage = GetStorage();

  //TIMELINE - FOR ANALYTICS CARD
  final timeLines = <String>[
    'Last 7 Days',
    'Last 30 Days',
    'This Month',
    'Last Month',
  ];
  RxString selectedTimeline = 'Last 7 Days'.obs;
  RxInt currentTimeFilterIndex = 0.obs;

  updateFilterTimeLine(String? newValue) {
    if (newValue != null) {
      selectedTimeline.value = newValue;
      currentTimeFilterIndex.value = timeLines.indexOf(newValue);
    }
  }

  //REWARD TITLES LIST - for analytics dropdown
  RxList<String> rewardTitles = <String>["Select reward"].obs;
  RxString selectedTitle = "Select reward".obs;
  RxList<String> rewardIds = <String>[].obs;

  //BUSINESS ANALYTICS
  Rxn<BusinessAnalyticsModel> businessAnalyticsModel =
      Rxn<BusinessAnalyticsModel>(null);

  //REDEMPTION METHOD MODEL
  RxList<RedemptionMethodModel> methods = <RedemptionMethodModel>[].obs;

  //TOP REWARDS LIST
  RxList<TopRewardModel> topRewards = <TopRewardModel>[].obs;

  //CONTROL TOP REWARDS LOADING - SHOW PROGRESSBAR
  RxBool isTopRewardsLoading = false.obs;

  //GET BUSINESS ANALYTICS
  getBusinessAnalytics() async {
    isTopRewardsLoading.value = true;

    topRewards.value = [];
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.businessAnalytics(
        timeFilter: analyticsTimeFilters[currentTimeFilterIndex.value],
      ),
    );
    isTopRewardsLoading.value = false;
    if (response.statusCode == 200) {
      businessAnalyticsModel.value = BusinessAnalyticsModel.fromJson(
          response.data['data']
      );
      methods.value = businessAnalyticsModel.value?.methods ?? [];
      topRewards.value = businessAnalyticsModel.value?.topRewards ?? [];
    }
  }
  
  
  Rxn<SummaryModel> summeryModel = Rxn<SummaryModel>(null);
  Rxn<RewardAnalyticsModel> model = Rxn<RewardAnalyticsModel>(null);
  RxList<GraphDataModel> graphs = <GraphDataModel>[].obs;
  
  //GET REWARD ANALYTICS FOR GRAPH
getRewardAnalyticsById({required String rewardId}) async{

    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.rewardAnalytics(rewardId: rewardId),
    );

    if( response.statusCode == 200 ){//FETCHED ANALYTICS
      model.value = RewardAnalyticsModel.fromJson( response.data['data'] );
      summeryModel.value = model.value?.summaryModel;
      graphs.value = model.value?.graphDataModels ?? [];
    }
}


//EXPORT TO CSV
exportToCsv( BusinessAnalyticsModel? model ) async{
  if( model == null ){
    showSnackBar(title: "No data found", message: "No analytics data found to export.", backgroundColor: AppColors.warningYellow);
    return;
  }
  //EXPORT TO CSV
  AnalyticsExporter exporter = AnalyticsExporter();
  exporter.exportToCSV( model );
}

//EXPORT TO CSV
  exportToPdf( BusinessAnalyticsModel? model ) async{
  if( model == null ){
    showSnackBar(title: "No data found", message: "No analytics data found to export.", backgroundColor: AppColors.warningYellow);
    return;
  }
    AnalyticsExporter exporter = AnalyticsExporter();
    exporter.exportToPDF( model );
  }
}
