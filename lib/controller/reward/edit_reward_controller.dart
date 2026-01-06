import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';
import 'package:organization/controller/reward/reward_controller.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';

class EditRewardController extends GetxController{

  RewardController rewardController = Get.find<RewardController>();

  final storage = GetStorage();

  RewardModel? model;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  RxString csvFileName = "".obs;
  final Rx<File?> csvFile = Rx<File?>(null);
  Rx<File?>? rewardImage = Rx<File?>(null);
  RxString rewardImageUrl = "".obs;
  RxBool isUpdating = false.obs;

  DateTime? dateTime;
  RxBool isInstore = true.obs;
  
  RxBool qrCode = false.obs;
  RxBool nfcTap = false.obs;
  RxBool staticCode = false.obs;
  RxBool discountCode = false.obs;
  RxBool giftCard = false.obs;

  //CONTROL CHECK BOXES - AT LEAST ONE VALUE MUST BE TRUE
  void toggleQrCode(bool value) {
    qrCode.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      qrCode.value = true; // keep at least one true
    }
  }
  void toggleStaticCode(bool value) {
    staticCode.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      staticCode.value = true;
    }
  }
  void toggleNfcTap(bool value) {
    nfcTap.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      nfcTap.value = true;
    }
  }

  //CONTROL CHECK BOXES - AT LEAST ONE VALUE MUST REMAIN TRUE
  void toggleDiscountCode(bool value) {
    discountCode.value = value;

    if (!discountCode.value && !giftCard.value) {
      discountCode.value = true; // keep at least one true
    }
  }

  void toggleGiftCard(bool value) {
    giftCard.value = value;

    if (!discountCode.value && !giftCard.value) {
      giftCard.value = true; // keep at least one true
    }
  }

  @override
  void onInit() {

    if (Get.arguments is RewardModel) {
      model = Get.arguments as RewardModel;
    } else {
      model = null;
    }

    initializeValues( model );

    super.onInit();
  }

  initializeValues( RewardModel? model ){
    if( model == null ){
      return;
    }

    isInstore.value = model.type == typeInStore;
    titleController.text = model.title;
    descriptionController.text = model.description;
    dateTime = model.expiryDate;
    limitController.text = model.redemptionLimit.toString();
    if( model.image != null ){
      rewardImageUrl.value = "${model.image}";
    }else{
      rewardImageUrl.value = "";
    }

    if( isInstore.value ){
      qrCode.value = model.inStoreMethods?.qrCode ?? false;
      nfcTap.value = model.inStoreMethods?.nfcTap ?? false;
      staticCode.value = model.inStoreMethods?.staticCode ?? false;
    }else{
      discountCode.value = model.onlineMethods?.discountCode ?? false;
      giftCard.value = model.onlineMethods?.giftCard ?? false;
    }
  }


  //UPDATE INSTORE REWARD
  updateInstoreReward() async{

    if( isUpdating.value ){
      return;
    }

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateReward(rewardId: model!.id ) );

    int? redemptionLimit;
    redemptionLimit = int.tryParse( limitController.text.trim() );
    redemptionLimit == null ? redemptionLimit = model?.redemptionLimit : redemptionLimit = redemptionLimit;

    final payLoad = {
      "title": titleController.text.trim().isEmpty ? model?.title : titleController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? model?.description : descriptionController.text.trim(),
      "category": model?.category,
      "redemptionLimit": redemptionLimit ?? 10,
      "startDate": model?.startDate.toIso8601String(),
      "expiryDate": dateTime?.toIso8601String(),
      "featured": model?.featured,
      "isActive": model?.isActive,
      "updateReason": "Updated redemption methods and expiry date",
      "inStoreRedemptionMethods": {
        "qrCode": qrCode.value,
        "staticCode": staticCode.value,
        "nfcTap": nfcTap.value
      },
      "onlineRedemptionMethods": null
    };

    try{
      isUpdating.value = true;
      var request = http.MultipartRequest("PATCH", uri );
      request.headers.addAll({
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        "Content-Type": "application/json",
      });

      request.fields["data"] = jsonEncode( payLoad );

      if( rewardImage?.value != null ){
        final compressedImage = await compressImage( rewardImage!.value! );
        if( compressedImage != null ){
          final mimeType =
              lookupMimeType(compressedImage.path)?.split('/') ??
                  ['application', 'octet-stream'];

          request.files.add(
              await http.MultipartFile.fromPath(
                "rewardImage",
                compressedImage.path,
                contentType: http.MediaType(
                  mimeType[0],
                  mimeType[1],
                ),
              )
          );
        }
      }

      var response = await request.send();

      if( response.statusCode == 200 ){//REWARD UPDATED
        //GO BACK TO REWARDS SCREEN
        rewardController.getAllRewards();
        Get.back();
        showSnackBar(
            title: "Done!",
            message: "Reward updated successfully.",
            backgroundColor: AppColors.successGreen
        );
      }else if( response.statusCode == 400 ){
        showSnackBar(title: "Error!", message: "Something went wrong. Please try again.", backgroundColor: AppColors.errorRed);
      }else if( response.statusCode == 429 ){//TOO MANY REQUEST
        showSnackBar(
          title: "Update Limit Reached",
          message: "Redemption limit updates are allowed every 24 hours.",
          backgroundColor: AppColors.warningYellow,
        );
      }
    }catch(e){
      showSnackBar(
          title: "No internet!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      isUpdating.value = false;
    }
  }

  //UPDATE ONLINE REWARD
  updateOnlineReward() async{

    if( isUpdating.value ){
      return;
    }

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateReward(rewardId: model!.id ) );

    final payLoad = {
      "title": titleController.text.trim().isEmpty ? model?.title : titleController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? model?.description : descriptionController.text.trim(),
      "category": model?.category,
      "redemptionLimit": model?.redemptionLimit,
      "startDate": model?.startDate.toIso8601String(),
      "expiryDate": dateTime?.toIso8601String(),
      "featured": model?.featured,
      "isActive": model?.isActive,
      "updateReason": "Updated redemption methods and expiry date",
      "inStoreRedemptionMethods": null,
      "onlineRedemptionMethods": {
        "giftCard": giftCard.value,
        "discountCode": discountCode.value,
      },
    };


    try{
      isUpdating.value = true;
      var request = http.MultipartRequest("PATCH", uri );
      request.headers.addAll({
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        "Content-Type": "application/json",
      });

      request.fields["data"] = jsonEncode( payLoad );

      if( rewardImage?.value != null ){
        final compressedImage = await compressImage( rewardImage!.value! );
        if( compressedImage != null ){
          final mimeType =
              lookupMimeType(compressedImage.path)?.split('/') ??
                  ['application', 'octet-stream'];

          request.files.add(
              await http.MultipartFile.fromPath(
                "rewardImage",
                compressedImage.path,
                contentType: http.MediaType(
                  mimeType[0],
                  mimeType[1],
                ),
              )
          );
        }
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

      }

      var response = await request.send();

      if( response.statusCode == 200 ){//REWARD UPDATED
        //GO BACK TO REWARDS SCREEN
        rewardController.getAllRewards();
        Get.back();
        showSnackBar(
            title: "Done!",
            message: "Reward updated successfully.",
            backgroundColor: AppColors.successGreen
        );
      }else if( response.statusCode == 400 ){
        showSnackBar(title: "Error!", message: "Something went wrong. Please try again.", backgroundColor: AppColors.errorRed);
      }else if( response.statusCode == 429 ){//TOO MANY REQUEST
        showSnackBar(
          title: "Update Limit Reached",
          message: "Redemption limit updates are allowed every 24 hours.",
          backgroundColor: AppColors.warningYellow,
        );
      }
    }catch(e){
      showSnackBar(
          title: "No internet!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.warningYellow
      );
    }finally{
      isUpdating.value = false;
    }
  }


  //DELETE REWARD IMAGE
  deleteRewardImage() async{

    if( model?.image == null || model!.image!.isEmpty ){
      return;
    }

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.deleteRewardImage + model!.id );
      Map<String, String> headers = {
        "Content-type" : "application/json",
        "Authorization": storage.read( accessTokenKey )
      };
      await http.delete( uri, headers: headers );
    }catch(e){
    }
  }

  //COMPRESS IMAGE
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,// 0 - 100
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }
}