import 'dart:convert';

import 'package:get/get.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';

import '../../utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class PrivacyController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  RxString htmlData = "".obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getPrivacyPolicy();
    super.onInit();
  }

  getPrivacyPolicy() async {
    Map<String, String> headers = {'Accept': 'text/html, application/json'};
    isLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: false,
      endPoint: ApiEndpoints.termsAndConditions
    );
    isLoading.value = false;

    if (response.statusCode == 200) {
      htmlData.value = response.data['data']['privacyPolicy'];
    }
  }
}
