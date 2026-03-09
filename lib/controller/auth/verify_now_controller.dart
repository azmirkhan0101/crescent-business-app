import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/show_snackbar.dart';
import '../../utils/api_endpoints.dart';

class VerifyNowController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();
  RxBool isVerificationLoading = false.obs;

  String? email() {
    return storage.read(emailKey);
  }

  //VERIFY NOW CLICK -> SEND SIGNUP OTP ( SAME AS RESEND SIGNUP OTP )
  void sendVerificationOtp() async {
    if (isVerificationLoading.value) {
      return;
    }

    isVerificationLoading.value = true;
    Map<String, String> payLoad = {"email": email()!};
    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpResendSignup,
      body: payLoad,
    );
    isVerificationLoading.value = false;

    if (response.statusCode == 200) {
      Get.snackbar("OTP sent!", "an OTP has been sent to your email.");
      Map<String, dynamic> arguments = {emailKey: email()!, isSignupKey: true};
      Get.offNamed(AppRoutes.otpVerify, arguments: arguments);
    } else if (response.statusCode == 400) {
      Get.snackbar("OTP already sent", "Check your mail and enter the otp.");
      Map<String, dynamic> arguments = {emailKey: email()!, isSignupKey: true};
      Get.offNamed(AppRoutes.otpVerify, arguments: arguments);
    } else {
      showSnackBar(
        title: "Error!",
        message: "Something went wrong. Please try again,",
        backgroundColor: AppColors.errorRed,
      );
    }
  }
}
