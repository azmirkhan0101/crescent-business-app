import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/analytics/business_analytics_model.dart';
import 'package:organization/data/models/analytics/top_rewards_model.dart';

import '../../utils/api_endpoints.dart';
import '../../utils/app_constants.dart';

class AnalyticsController extends GetxController{

  @override
  void onInit() {

    getBusinessAnalytics();
    super.onInit();
  }

  final storage = GetStorage();
  //BUSINESS ANALYTICS
  Rxn<BusinessAnalyticsModel> businessAnalyticsModel = Rxn<BusinessAnalyticsModel>(null);
  //TOP REWARDS LIST
  RxList<TopRewardModel> topRewards = <TopRewardModel>[].obs;
  //CONTROL TOP REWARDS LOADING - SHOW PROGRESSBAR
  RxBool isTopRewardsLoading = false.obs;

  //GET BUSINESS ANALYTICS FROM
  getBusinessAnalytics() async {

    isTopRewardsLoading.value = true;

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.businessAnalytics );

    Map<String, String> header = {
      'Authorization': 'Bearer ${storage.read(accessTokenKey)}'
    };

    try{
      http.Response response = await http.get(uri, headers: header);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print("Successsssss business analytics");
        businessAnalyticsModel.value = BusinessAnalyticsModel.fromJson( jsonDecode(response.body)['data'] );
        topRewards.value = businessAnalyticsModel.value?.topRewards ?? [];
      }
    }catch(e){
      print("Business analytics catch: ${e}");
    }finally{
      isTopRewardsLoading.value = false;
    }

  }
}