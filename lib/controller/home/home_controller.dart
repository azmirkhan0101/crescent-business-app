import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/data/models/home/home_stats_model.dart';
import 'package:organization/data/models/home/monthly_stats.dart';
import 'package:organization/data/models/home/recent_activity_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:organization/utils/app_constants.dart';

class HomeController extends GetxController{

  @override
  void onInit() {

    getBusinessOverview();
    getRecentActivity();
    super.onInit();
  }

  final storage = GetStorage();
  RxBool isRecentActivityLoading = true.obs;
  RxList<RecentActivityModel> recentActivities = <RecentActivityModel>[].obs;
  Rxn<HomeStatsModel> homeStatModel = Rxn<HomeStatsModel>(null);
  RxList<MonthlyStats> monthlyStats = <MonthlyStats>[].obs;

  //GET BUSINESS OVERVIEW - HOME SCREEN STATS
  getBusinessOverview() async{

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.businessOverview );
      Map<String, String> headers = {
        "Authorization": "${storage.read( accessTokenKey )}"
      };
      http.Response response = await http.get( uri, headers: headers );

      print("Status: ${response.statusCode}");
      print("Overview: ${response.body}");

      if( response.statusCode == 200 ){
        //TODO: PARSE THE RESPONSE HERE
        homeStatModel.value = HomeStatsModel.fromJson( jsonDecode( response.body)['data'] );
        monthlyStats.value = homeStatModel.value?.monthlyStats ?? [];
      }
    }catch(e){
      print("Something wrong: ${e}");
    }finally{
      print( "Finally: ${homeStatModel.value?.overview.lastSevenDaysRedeemed}");
    }
  }


  //GET RECENT ACTIVITY
getRecentActivity() async{

  isRecentActivityLoading.value = true;

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.recentActivity );
    Map<String, String> headers = {
      "Authorization": "Bearer ${storage.read( accessTokenKey )}"
    };

    try{
      http.Response response = await http.get( uri, headers: headers );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if( response.statusCode == 200 ){
        //TODO: PARSE RESPONSE AND SHOW IN UI
        final decoded = jsonDecode(response.body);

        recentActivities.value = (decoded['data'] as List? ?? [])
            .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }catch(e){
     print("Recent catch: ${e}");
    }finally{
      isRecentActivityLoading.value = false;
    }
}

}