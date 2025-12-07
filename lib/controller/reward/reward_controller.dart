import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/reward_card_model.dart';
import 'package:organization/data/models/reward_create_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/assets_path.dart';

class RewardController extends GetxController {

  final storage = GetStorage();
  RxList<RewardCardModel> rewards2 = <RewardCardModel>[].obs;
  RewardCreateModel? createModel;
  String category = categories[0];

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
  RxBool giftCard = true.obs;
  //Rx<File?> rewardImage = Rx<File?>(null);
  final Rx<File?> rewardImage = Rx<File?>(null);

  DateTime expiryDate = DateTime( 2050, 1, 1);//TODO: DEFAULT EXPIRY ON 2050, ASK BACKEND ABOUT IT

  //CREATE REWARD CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();//TODO: NO USAGE IN UI, ASK BACKEND
  final TextEditingController startDate = TextEditingController();//TODO: NO NEED. GENERATE TIME DURING API CALL
  final TextEditingController redemptionLimitController = TextEditingController();

  //DUMMY REWARDS
  RxList<RewardCardModel> rewards = <RewardCardModel>[
    RewardCardModel(
      title: "Reward 1",
      assetIcon: AssetsPath.rewardFreeIcon,
      expiryDate: "30 Jan 2026",
      redemptions: 80,
    ),
    RewardCardModel(
      title: "Reward 2",
      assetIcon: AssetsPath.rewardDiscountIcon,
      expiryDate: "2 Feb 2026",
      redemptions: 300,
    ),
    RewardCardModel(
      title: "Reward 3",
      assetIcon: AssetsPath.rewardDiscountIcon,
      expiryDate: "12 Jun 2026",
      redemptions: 250,
    ),
    RewardCardModel(
      title: "Reward 4",
      assetIcon: AssetsPath.rewardFreeIcon,
      expiryDate: "5 April 2026",
      redemptions: 130,
    ),
    RewardCardModel(
      title: "Reward 5",
      assetIcon: AssetsPath.rewardDiscountIcon,
      expiryDate: "7 March 2026",
      redemptions: 60,
    ),
  ].obs;

  //GET REWARDS FROM API
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

  //VALIDATE TITLE, DESCRIPTION

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

    String businessID = "6933cbce613096a0dc5420a5";//dummy
    createModel = RewardCreateModel(
        //businessId: storage.read( businessIdKey ) ?? businessID,
        businessId: businessID,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: "in-store",//hard coded
        category: category.toLowerCase(),
        redemptionLimit: redemptionLimit!,
        startDate: DateTime.now(),
        expiryDate: expiryDate,
        inStoreRedemptionMethods: InStoreRedemptionMethods(
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

      request.fields["data"] = jsonEncode( createModel!.toJson() );

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
        showSnackBar(
            title: "Done!",
            message: "Reward created successfully",
            backgroundColor: AppColors.successGreen
        );
        //GET REWARD LIST -> GO BACK TO REWARDS SCREEN
        Get.back();
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



  //CREATE REWARD IN STORE
  createRewardOnline() async{

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

    String businessID = "6933cbce613096a0dc5420a5";//dummy
    createModel = RewardCreateModel(
      //businessId: storage.read( businessIdKey ) ?? businessID,
        businessId: businessID,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: "online",//hard coded
        category: category.toLowerCase(),
        redemptionLimit: redemptionLimit!,
        startDate: DateTime.now(),
        expiryDate: expiryDate,
        inStoreRedemptionMethods: InStoreRedemptionMethods(
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

      request.fields["data"] = jsonEncode( createModel!.toJson() );

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
        showSnackBar(
            title: "Done!",
            message: "Reward created successfully",
            backgroundColor: AppColors.successGreen
        );
        //GET REWARD LIST -> GO BACK TO REWARDS SCREEN
        Get.back();
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


}
//END OF CLASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS