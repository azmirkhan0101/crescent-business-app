import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/data/models/home/home_stats_model.dart';
import 'package:organization/data/models/home/monthly_stats.dart';
import 'package:organization/data/models/home/recent_activity_model.dart';
import 'package:organization/data/models/profile/business_profile_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';
import '../../core/api_service.dart';
import '../../core/subscription_service.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _checkAccessAndLoad();
  }

  Future<void> _checkAccessAndLoad() async {
    // 1. Force a refresh of the premium status combining RC + Backend
    await SubscriptionService.to.checkPremiumStatus();

    // 2. If both 6-month free premium AND revenuecat premium are expired/inactive
    if (!SubscriptionService.to.hasPremium) {
      Get.offAllNamed(AppRoutes.paywallScreen);
      return;
    }

    // 3. User is valid, fetch home data
    getBusinessOverview();
    getRecentActivity();
    getProfileData();
  }

  final storage = GetStorage();
  RxString profileImageUrl = "".obs;
  RxString userName = "".obs;
  RxBool isRecentActivityLoading = true.obs;
  RxList<RecentActivityModel> recentActivities = <RecentActivityModel>[].obs;
  Rxn<HomeStatsModel> homeStatModel = Rxn<HomeStatsModel>(null);
  RxList<MonthlyStats> monthlyStats = <MonthlyStats>[].obs;

  getProfileData() {
    var profileData = storage.read(businessProfileModelKey);
    if (profileData != null) {
      BusinessProfileModel model = BusinessProfileModel.fromJson(profileData);
      profileImageUrl.value = model.logoImage == null || model.logoImage!.isEmpty
          ? ""
          : "${model.logoImage}";
      userName.value = model.name ?? "";
    }
  }

  getBusinessOverview() async {
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.businessOverview,
    );
    if (response.statusCode == 200) {
      homeStatModel.value = HomeStatsModel.fromJson(response.data['data']);
      monthlyStats.value = homeStatModel.value?.monthlyStats ??[];
    }
  }

  getRecentActivity() async {
    isRecentActivityLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.recentActivity,
    );
    isRecentActivityLoading.value = false;
    if (response.statusCode == 200) {
      recentActivities.value = (response.data['data'] as List? ??[])
          .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}