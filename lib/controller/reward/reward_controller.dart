import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/reward/instore_reward_create_model.dart';
import 'package:organization/data/models/reward/online_reward_create_model.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class RewardController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  ScrollController scrollController = ScrollController();

  //EDIT
  RewardModel? editModel;

  @override
  void onInit() {
    getAllRewards();
    scrollController.addListener(() {
      if (isMoreLoading.value || !hasMoreData) return;
      // Trigger when user scrolls to 90% of the page
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        getAllRewards(isRefresh: false);
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  final storage = GetStorage();
  RxBool isCreating = false.obs;
  InStoreRewardCreateModel? inStoreCreateModel;
  OnlineRewardCreateModel? onlineCreateModel;
  String category = categories[0];

  //REWARDS
  RxList<RewardModel> rewards = <RewardModel>[].obs;

  //LOADING CONTROL
  RxBool isLoading = true.obs;

  //FILTER LOADING CONTROL
  RxBool isFilterLoading = false.obs;

  //PAGINATION
  RxBool isMoreLoading = false.obs;
  int currentPage = 1;
  bool hasMoreData = true;

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

  //ONLINE OPTIONS
  RxBool discountCode = true.obs;
  RxBool giftCard = false.obs;

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
      giftCard.value = true;
    }
  }

  final Rx<File?> rewardImage = Rx<File?>(null);
  final Rx<File?> csvFile = Rx<File?>(null);

  DateTime? expiryDate;

  //CREATE REWARD CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController redemptionLimitController =
      TextEditingController();

  //['all', 'active', 'disabled', 'expires_soon'] - filter reference
  //DEFAULT FILTER "all"
  final RxString selectedFilter = 'all'.obs;

  //GET ALL REWARDS
  getAllRewards({bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreData = true;
      isLoading.value = true;
    } else {
      // If already loading or no more data to fetch, exit
      if (isMoreLoading.value || !hasMoreData) return;
      isMoreLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      isAuthRequired: true,
      endPoint: ApiEndpoints.getAllRewards(
        status: selectedFilter.value,
        page: currentPage,
      ),
    );
    isLoading.value = false;
    isMoreLoading.value = false;
    isFilterLoading.value = false;

    if (response.statusCode == 200) {
      var tempRewards = response.data['data'] as List<dynamic>? ?? [];
      // Filter and Map the data
      List<RewardModel> fetchedRewards = tempRewards.map((e) {
        return RewardModel.fromJson(e);
      }).toList();
      if (isRefresh) {
        rewards.value = fetchedRewards;
      } else {
        rewards.addAll(fetchedRewards);
      }
      // Logic to check if we should stop pagination
      // If the API returns fewer than 10 items, we've reached the end
      if (fetchedRewards.length < 10) {
        hasMoreData = false;
      } else {
        currentPage++;
      }
    }
  }

  //CREATE REWARD IN STORE
  createRewardInStore() async {
    if (isCreating.value) {
      return;
    }

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      showSnackBar(
        title: "Enter details",
        message: "Enter title and description to create a new reward.",
        backgroundColor: AppColors.errorRed,
      );
      return;
    } else {
      redemptionLimit = int.tryParse(redemptionLimitController.text.trim());
      redemptionLimit == null || redemptionLimit! < 1
          ? redemptionLimit = 10000
          : redemptionLimit = redemptionLimit; //DEFAULT LIMIT 10,000
      redemptionLimit! > 10000
          ? redemptionLimit = 10000
          : redemptionLimit = redemptionLimit; //MAX LIMIT 10,000
    }

    inStoreCreateModel = InStoreRewardCreateModel(
      businessId: storage.read(businessIdKey),
      title: capitalizeFirstLetter(titleController.text.trim()),
      description: descriptionController.text.trim(),
      type: "in-store",
      category: category.toLowerCase(),
      redemptionLimit: redemptionLimit!,
      startDate: DateTime.now().toUtc(),
      expiryDate: expiryDate ?? DateTime(2050, 1, 1).toUtc(),
      inStoreRedemptionMethods: CreateInStoreRedemptionMethods(
        qrCode: qrCode.value,
        staticCode: staticCode.value,
        nfcTap: nfcTap.value,
      ),
      onlineRedemptionMethods: null,
      featured: true,
    );

    isCreating.value = true;
    ApiResponse response = await apiService.multipartRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: ApiEndpoints.createRewardInStore,
      fields: inStoreCreateModel!.toJson(),
      rewardImage: rewardImage.value
    );
    isCreating.value = false;

    if (response.statusCode == 201) {
      //REWARD CREATED
      //GO BACK TO REWARDS SCREEN
      qrCode.value = true;
      staticCode.value = false;
      nfcTap.value = false;
      titleController.clear();
      descriptionController.clear();
      rewardImage.value = null;
      expiryDate = null;
      redemptionLimitController.clear();
      getAllRewards();
      Get.back();
      showSnackBar(
        title: "Done!",
        message: "Reward created successfully",
        backgroundColor: AppColors.successGreen,
      );
    } else {
      showSnackBar(
        title: "Error occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //CREATE REWARD ONLINE
  createRewardOnline() async {
    if (isCreating.value) {
      return;
    }

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      showSnackBar(
        title: "Enter details",
        message: "Enter title and description to create a new reward.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }

    if (csvFile.value == null) {
      showSnackBar(
        title: "Codes required!",
        message: "CSV file is required to create online reward.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }

    onlineCreateModel = OnlineRewardCreateModel(
      businessId: storage.read(businessIdKey),
      title: capitalizeFirstLetter(titleController.text.trim()),
      description: descriptionController.text.trim(),
      type: "online",
      //hard coded
      category: category.toLowerCase(),
      startDate: DateTime.now().toUtc(),
      expiryDate: expiryDate ?? DateTime(2050, 1, 1),
      onlineRedemptionMethods: CreateOnlineRedemptionMethods(
        giftCard: giftCard.value,
        discountCode: discountCode.value,
      ),
      featured: false,
    );

    isCreating.value = true;

    ApiResponse response = await apiService.multipartRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: ApiEndpoints.createRewardOnline,
      fields: onlineCreateModel!.toJson(),
      rewardImage: rewardImage.value,
      csvFile: csvFile.value
    );
    isCreating.value = false;

    if (response.statusCode == 201) {
      //REWARD CREATED
      //GET REWARD LIST -> GO BACK TO REWARDS SCREEN
      discountCode.value = true;
      giftCard.value = false;
      titleController.clear();
      descriptionController.clear();
      rewardImage.value = null;
      expiryDate = null;
      redemptionLimitController.clear();
      getAllRewards();
      Get.back();
      showSnackBar(
        title: "Done!",
        message: "Reward created successfully",
        backgroundColor: AppColors.successGreen,
      );
    } else if (response.statusCode == 409) {
      showSnackBar(
        title: "Repeated code!",
        message: "Some codes were found repeated. Try again with new codes.",
        backgroundColor: AppColors.warningYellow,
      );
    } else {
      showSnackBar(
        title: "Error Occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.warningYellow,
      );
    }
  }

  //UPDATE REWARD STATUS - FROM TOGGLE SWITCH IN REWARD CARD
  updateRewardStatus({required String rewardId, required bool isActive}) async {
    Map<String, bool> payLoad = {"isActive": isActive};
    await apiService.networkRequest(
      method: "PATCH",
      isAuthRequired: true,
      endPoint: ApiEndpoints.updateRewardStatus(rewardID: rewardId),
      body: payLoad,
    );
  }

  //DELETE REWARD
  deleteReward({required String rewardId, required int index}) async {
    ApiResponse response = await apiService.networkRequest(
      method: "DELETE",
      isAuthRequired: true,
      endPoint: ApiEndpoints.deleteReward + rewardId,
    );

    if (response.statusCode == 200) {
      rewards.removeAt(index);
      showSnackBar(
        title: "Reward deleted",
        message: "The reward has been deleted.",
        backgroundColor: AppColors.successGreen,
      );
    } else if (response.statusCode == 400) {
      showSnackBar(
        title: "Failed!",
        message: "Cannot delete active reward.",
        backgroundColor: AppColors.warningYellow,
      );
    } else if (response.statusCode == 409) {
      showSnackBar(
        title: "Failed!",
        message: "Cannot delete claimed reward.",
        backgroundColor: AppColors.warningYellow,
      );
    } else {
      showSnackBar(
        title: "Failed!",
        message: "Please try again.",
        backgroundColor: AppColors.warningYellow,
      );
    }
  }

  //REWARD TITLE FIRST LETTER UPPERCASE
  String capitalizeFirstLetter(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
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
      quality: 50, // 0 - 100
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }
}

//END OF CLASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
