import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/analytics/business_analytics_model.dart';
import 'package:organization/data/models/analytics/redemption_method_model.dart';
import 'package:organization/data/models/analytics/reward_analytics_model.dart';
import 'package:organization/data/models/analytics/summary_model.dart';
import 'package:organization/data/models/analytics/top_rewards_model.dart';
import 'package:organization/data/models/reward/reward_model.dart';

import '../../utils/api_endpoints.dart';
import '../../utils/app_constants.dart';
import '../reward/reward_controller.dart';

class AnalyticsController extends GetxController {

  final RewardController rewardController = Get.find<RewardController>();

  @override
  void onInit() {
    getBusinessAnalytics();

    ever( rewardController.rewards, (newData) {
      print("Analytics detected new reward data: ${newData.length}");
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

    Uri uri = Uri.parse(
      ApiEndpoints.baseUrl +
          ApiEndpoints.businessAnalytics(
            timeFilter: analyticsTimeFilters[currentTimeFilterIndex.value],
          ),
    );

    Map<String, String> header = {
      'Authorization': 'Bearer ${storage.read(accessTokenKey)}',
    };

    try {
      http.Response response = await http.get(uri, headers: header);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print("Successsssss business analytics");
        businessAnalyticsModel.value = BusinessAnalyticsModel.fromJson(
          jsonDecode(response.body)['data'],
        );
        methods.value = businessAnalyticsModel.value?.methods ?? [];
        print("Successsssss222222222222 business analytics");
        topRewards.value = businessAnalyticsModel.value?.topRewards ?? [];
      }
    } catch (e) {
      print("Business analytics catch: ${e}");
    } finally {
      isTopRewardsLoading.value = false;
    }
  }
  
  
  Rxn<SummaryModel> summeryModel = Rxn<SummaryModel>(null);
  Rxn<RewardAnalyticsModel> model = Rxn<RewardAnalyticsModel>(null);
  
  //GET REWARD ANALYTICS FOR GRAPH
getRewardAnalyticsById({required String rewardId}) async{
    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.rewardAnalytics(rewardId: rewardId));

    Map<String, String> header = {
      'Authorization': 'Bearer ${storage.read(accessTokenKey)}',
    };

    try{
      http.Response response = await http.get( uri, headers: header );

      print("Reward Id: ${rewardId}");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if( response.statusCode == 200 ){//FETCHED ANALYTICS
        model.value = RewardAnalyticsModel.fromJson( jsonDecode( response.body )['data'] );
        summeryModel.value = model.value?.summaryModel;
      }
    }catch(e){

    }


}
}
