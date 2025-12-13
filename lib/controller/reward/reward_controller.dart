import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/instore_reward_create_model.dart';
import 'package:organization/data/models/online_reward_create_model.dart';
import 'package:organization/data/models/reward_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';

class RewardController extends GetxController {

  @override
  void onInit() {

    getAllRewards();
    super.onInit();
  }

  final storage = GetStorage();
  InStoreRewardCreateModel? inStoreCreateModel;
  OnlineRewardCreateModel? onlineCreateModel;
  String category = categories[0];
  //REWARDS
  RxList<RewardModel> rewards = <RewardModel>[].obs;
  //LOADING CONTROLL
  RxBool isLoading = true.obs;

  static const List<String> categories = [
    "Food",
    "Clothing",
    "Groceries",
    "Health",
    "Beauty",
    "Electronics",
    "Entertainment",
    "Travel",
    "Fitness",
    "Education",
    "Other",
  ];
  int? redemptionLimit;
  //IN STORE OPTIONS
  RxBool qrCode = true.obs;
  RxBool staticCode = false.obs;
  RxBool nfcTap = false.obs;
  //ONLINE OPTIONS
  RxBool discountCode = true.obs;
  RxBool giftCard = false.obs;
  final Rx<File?> rewardImage = Rx<File?>(null);
  final Rx<File?> csvFile = Rx<File?>(null);

  DateTime? expiryDate;

  //CREATE REWARD CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();//TODO: NO USAGE IN UI, ASK BACKEND
  final TextEditingController startDate = TextEditingController();//TODO: NO NEED. GENERATE TIME DURING API CALL
  final TextEditingController redemptionLimitController = TextEditingController();


  //GET ALL REWARDS
  getAllRewards() async{
    isLoading.value = true;
    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.getAllRewards );

      Map<String, String> headers = {
        "Authorization" : "Bearer ${storage.read( accessTokenKey )}"
      };

      http.Response response = await http.get( uri, headers: headers );

      if( response.statusCode == 200 ){
        var tempRewards = jsonDecode(response.body)['data'] as List;
        rewards.value = tempRewards.map((e){
          return RewardModel.fromJson(e);
        }).toList();
      }

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
    }catch(e){
    }finally{
      isLoading.value = false;
    }
  }


  //GET REWARD ANALYTICS FROM API
  getRewardAnalyticsStats() async {
    //TODO: USE THE SAVED ONE
    //String businessID = storage.read( businessIdKey );
    String businessID = "69310d25aa6d1208849d5c42";//dummy

    final Uri uri = Uri.parse(
      ApiEndpoints.baseUrl +
          ApiEndpoints.rewardAnalyticsStats +
          "?businessId" +
          "=" +
          businessID,
    );
    print("Uri: ${uri}");

    Map<String, String> header = {
      'Authorization': 'Bearer ${storage.read(accessTokenKey)}',
      'Accept': 'application/json',
    };

    try{
      http.Response response = await http.get(uri, headers: header);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        //REWARDS FETCHED
      } else {
        showSnackBar(
            title: "Error occurred!",
            message: "Something went wrong. Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      showSnackBar(
          title: "No internet!",
          message: "Please connect internet and try again.",
          backgroundColor: AppColors.errorRed
      );
    }

  }

  //SAMPLE RESPONSE OF GET REWARDS
  Map<String, dynamic> responseSample = {
    "success": true,
    "message": "Statistics retrieved successfully",
    "data": {
      "totalRewards": 0,
      "activeRewards": 0,
      "expiredRewards": 0,
      "soldOutRewards": 0,
      "totalRedemptions": 0,
      "totalViews": 0,
      "averageRedemptionRate": 0,
      "topRewards": [],
      "rewardsByCategory": [],
      "rewardsByType": {"inStore": 0, "online": 0},
    },
  };

//CREATE REWARD IN STORE
  createRewardInStore() async{

    if( titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty ){
      showSnackBar(
          title: "Enter details",
          message: "Enter title and description to create a new reward.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }else{
      redemptionLimit = int.tryParse( redemptionLimitController.text.trim() );
      redemptionLimit == null || redemptionLimit! < 1 ? redemptionLimit = 10000 : redemptionLimit = redemptionLimit;//DEFAULT LIMIT 10,000
      redemptionLimit! > 10000 ? redemptionLimit = 10000 : redemptionLimit = redemptionLimit;//MAX LIMIT 10,000
    }
    
    Uri url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.createRewardInStore );

    inStoreCreateModel = InStoreRewardCreateModel(
        businessId: storage.read( businessIdKey ),
        title: capitalizeFirstLetter(titleController.text.trim()),
        description: descriptionController.text.trim(),
        type: "in-store",//hard coded
        category: category.toLowerCase(),
        redemptionLimit: redemptionLimit!,
        startDate: DateTime.now(),
        expiryDate: expiryDate ?? DateTime( 2050, 1, 1),
        inStoreRedemptionMethods: CreateInStoreRedemptionMethods(
            qrCode: qrCode.value,
            staticCode: staticCode.value,
            nfcTap: nfcTap.value
        ),
        onlineRedemptionMethods: null,
        featured: true
    );

    try{
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        "Content-Type": "application/json",
      });

      request.fields["data"] = jsonEncode( inStoreCreateModel!.toJson() );

      if( rewardImage.value != null ){
        request.files.add(
            await http.MultipartFile.fromPath(
                "rewardImage",
                rewardImage.value!.path
            )
        );
      }

      var response = await request.send().timeout(Duration(seconds: 10));
      var responseBody = await response.stream.bytesToString();

      if( response.statusCode == 201 ){//REWARD CREATED
        //GO BACK TO REWARDS SCREEN
        getAllRewards();
        Get.back();
        showSnackBar(
            title: "Done!",
            message: "Reward created successfully",
            backgroundColor: AppColors.successGreen
        );
      }

      print("Status: ${response.statusCode}");
      print("Body: $responseBody");
    }on TimeoutException catch(_){
      showSnackBar(
          title: "Time out!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    } catch(e){
      showSnackBar(
          title: "No internet!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    }
  }

  //CREATE REWARD ONLINE
  createRewardOnline() async{

    if( titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty ){
      showSnackBar(
          title: "Enter details",
          message: "Enter title and description to create a new reward.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    Uri url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.createRewardInStore );//SAME ENDPOINT FOR BOTH

    onlineCreateModel = OnlineRewardCreateModel(
        businessId: storage.read( businessIdKey ),
        title: capitalizeFirstLetter(titleController.text.trim()),
        description: descriptionController.text.trim(),
        type: "online",//hard coded
        category: category.toLowerCase(),
        startDate: DateTime.now(),
        expiryDate: expiryDate ?? DateTime( 2050, 1, 1),
        onlineRedemptionMethods: CreateOnlineRedemptionMethods(
            giftCard: giftCard.value,
            discountCode: discountCode.value
        ),
        featured: false
    );

    try{
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        //"Content-Type": "application/json",
      });

      request.fields["data"] = jsonEncode( onlineCreateModel!.toJson() );

      //REWARD IMAGE
      if( rewardImage.value != null ){
        request.files.add(
            await http.MultipartFile.fromPath(
                "rewardImage",
                rewardImage.value!.path
            )
        );
      }

      //CSV FILE FOR DISCOUNT CODES
      if( csvFile.value != null ){
        request.files.add(
          await http.MultipartFile.fromPath(
            "codesFiles",
            csvFile.value!.path,
            contentType: http.MediaType("text", "csv"),
          ),
        );
        print("CSV file: ${csvFile.value!.path}");
        //print("CSV file: ${csvFile.value!.}");
      }

      var response = await request.send().timeout(Duration(seconds: 10));
      var responseBody = await response.stream.bytesToString();

      print("Status: ${response.statusCode}");
      print("Body: $responseBody");

      if( response.statusCode == 201 ){//REWARD CREATED
        //GET REWARD LIST -> GO BACK TO REWARDS SCREEN
        getAllRewards();
        Get.back();
        showSnackBar(
            title: "Done!",
            message: "Reward created successfully",
            backgroundColor: AppColors.successGreen
        );
      }else if( response.statusCode == 409 ){
        showSnackBar(
            title: "Repeated code!",
            message: "Some codes were found repeated. Try again with new codes.",
            backgroundColor: AppColors.warningYellow
        );
      }
    }on TimeoutException catch(_){
      showSnackBar(
          title: "Time out!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    } catch(e){
      showSnackBar(
          title: "No internet!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    }
  }


  //DELETE REWARD
  deleteReward( String rewardId ) async{

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.deleteReward + rewardId );
      Map<String, String> headers = {
        "Authorization": storage.read( accessTokenKey )
      };
      http.Response response = await http.delete( uri, headers: headers );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      if( response.statusCode == 200 ){
        getAllRewards();
        showSnackBar(
            title: "Reward deleted",
            message: "The reward has been deleted.",
            backgroundColor: AppColors.successGreen
        );
      }
    }catch(e){
      showSnackBar(
          title: "Error occurred",
          message: "Couldn't delete the reward.",
          backgroundColor: AppColors.errorRed
      );
    }
  }

  //REWARD TITLE FIRST LETTER UPPERCASE
  String capitalizeFirstLetter(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

}
//END OF CLASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS