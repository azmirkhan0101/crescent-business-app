import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/home/home_stats_model.dart';
import 'package:organization/data/models/home/monthly_stats.dart';
import 'package:organization/data/models/home/recent_activity_model.dart';
import 'package:organization/data/models/profile/business_profile_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

class HomeController extends GetxController{

  @override
  void onInit() {

    if( isSubscriptionExpired() ){
      Get.offAllNamed( AppRoutes.subscription );
      return;
    }

    getBusinessOverview();
    getRecentActivity();
    getProfileData();
    super.onInit();
  }

  bool isSubscriptionExpired(){
    String? subscriptionExpiryDate = storage.read( subscriptionExpiryDateKey );
    if( subscriptionExpiryDate == null && storage.read( subscriptionKey) == false ) return true;
    DateTime expiryDate = DateTime.parse( subscriptionExpiryDate! );
    DateTime nowUtc = DateTime.now().toUtc();

    return nowUtc.isAfter( expiryDate );
  }


  final storage = GetStorage();
  RxString profileImageUrl = "".obs;
  RxString userName = "".obs;
  RxBool isRecentActivityLoading = true.obs;
  RxList<RecentActivityModel> recentActivities = <RecentActivityModel>[].obs;
  Rxn<HomeStatsModel> homeStatModel = Rxn<HomeStatsModel>(null);
  RxList<MonthlyStats> monthlyStats = <MonthlyStats>[].obs;

  //GET PROFILE IMAGE URL AND USERNAME FROM STORAGE
  getProfileData(){
    BusinessProfileModel? model = BusinessProfileModel.fromJson(storage.read( businessProfileModelKey ));
    profileImageUrl.value = model.logoImage == null || model.logoImage!.isEmpty
        ? ""
        : "${model.logoImage}";
    userName.value = model.name;
    }

  //GET BUSINESS OVERVIEW - HOME SCREEN STATS
  getBusinessOverview() async{

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.businessOverview );
      Map<String, String> headers = {
        "Content-type" : "application/json",
        "Authorization": "${storage.read( accessTokenKey )}"
      };
      http.Response response = await http.get( uri, headers: headers );

      if( response.statusCode == 200 ){
        homeStatModel.value = HomeStatsModel.fromJson( jsonDecode( response.body)['data'] );
        monthlyStats.value = homeStatModel.value?.monthlyStats ?? [];
      }
    }catch(e){
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

      if( response.statusCode == 200 ){
        //TODO: PARSE RESPONSE AND SHOW IN UI
        final decoded = jsonDecode(response.body);

        recentActivities.value = (decoded['data'] as List? ?? [])
            .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }catch(e){
    }finally{
      isRecentActivityLoading.value = false;
    }
}

}