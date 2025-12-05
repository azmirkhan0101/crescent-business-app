import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/reward_card_model.dart';
import 'package:organization/data/models/reward_create_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/assets_path.dart';
import 'package:http/http.dart' as http;

class RewardController extends GetxController {

  final storage = GetStorage();
  RxList<RewardCardModel> rewards = <RewardCardModel>[].obs;
  RewardCreateModel? createModel;
  int? redemptionLimit;
  RxBool qrCode = true.obs;
  RxBool staticCode = false.obs;
  RxBool nfcTap = false.obs;
  File? rewardImage;

  //CREATE REWARD CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();//TODO: NO USAGE IN UI, ASK BACKEND
  final TextEditingController startDate = TextEditingController();//TODO: NO NEED. GENERATE TIME DURING API CALL
  final TextEditingController redemptionLimitController = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();

  //DUMMY REWARDS
  RxList<RewardCardModel> rewards2 = <RewardCardModel>[
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

    //TODO: CHECK REDEMPTION LIMIT
    if( titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty ){
      showSnackBar(
          title: "Enter details",
          message: "Enter title and description to create a new reward.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }else if( redemptionLimitController.text.trim().isEmpty ){
      showSnackBar(
          title: "Enter redemption limit",
          message: "Enter redemption limit to continue.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    redemptionLimit = int.tryParse( redemptionLimitController.text.trim() );
    redemptionLimit == null || redemptionLimit! <1 ? redemptionLimit = 1 : redemptionLimit = redemptionLimit;//DEFAULT LIMIT 1

    Uri url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.createRewardInStore );

    String businessID = "69310d25aa6d1208849d5c42";//dummy
    createModel = RewardCreateModel(
        businessId: storage.read( businessIdKey ) ?? businessID,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: "in-store",//hard coded
        category: "food",//hard coded TODO: ASK BACKEND, NO OPTION IN UI
        redemptionLimit: redemptionLimit!,
        startDate: DateTime.now(),
        expiryDate: DateTime.now(),
        inStoreRedemptionMethods: InStoreRedemptionMethods(
            qrCode: qrCode.value,
            staticCode: staticCode.value,
            nfcTap: nfcTap.value
        ),
        onlineRedemptionMethods: null,
        featured: true
    );

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      "Authorization": "Bearer ${storage.read( accessTokenKey )}",
      "Content-Type": "application/json",
    });

    request.fields["data"] = jsonEncode( createModel!.toJson() );

    if( rewardImage != null ){
      request.files.add(
          await http.MultipartFile.fromPath(
          "rewardImage",
          rewardImage!.path
      )
    );
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("Status: ${response.statusCode}");
    print("Body: $responseBody");
  }


}
//END OF CLASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS