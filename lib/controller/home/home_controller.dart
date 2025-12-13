import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/data/models/home_stats_model.dart';
import 'package:organization/data/models/monthly_stats.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:organization/utils/app_constants.dart';

class HomeController extends GetxController{

  final storage = GetStorage();
  RxBool isOverviewLoading = true.obs;
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
      }
    }catch(e){
      print("Something wrong: ${e}");
    }finally{
      print( "Finally: ${homeStatModel.value?.overview.lastSevenDaysRedeemed}");
    }
  }
}