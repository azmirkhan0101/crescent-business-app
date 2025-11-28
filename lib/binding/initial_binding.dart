import 'package:get/get.dart';
import 'package:organization/controller/auth/login_controller.dart';
import 'package:organization/controller/auth/setup_complete_controller.dart';
import 'package:organization/controller/auth/verify_now_controller.dart';
import 'package:organization/controller/main_navigation_screen_controller/main_navigation_screen_controller.dart';
import '../controller/auth/sign_up_controller.dart';
import '../controller/auth/forgot_pass_controller.dart';
import '../controller/auth/otp_verification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut((){
      return MainNavigationScreenController();
    }, fenix: true);

    Get.lazyPut<SignUpController>((){
      return SignUpController();
    }, fenix: true);

    Get.lazyPut<SetupCompleteController>((){
      return SetupCompleteController();
    }, fenix: true,);

    Get.lazyPut<LoginController>((){
      return LoginController();
    }, fenix: true);

    Get.lazyPut<ForgotPasswordController>((){
      return ForgotPasswordController();
    },fenix: true,);

    Get.lazyPut<VerifyNowController>((){
      return VerifyNowController();
    },fenix: true,);

    Get.lazyPut<OtpVerificationController>((){
      return OtpVerificationController();
    }, fenix: true,);
  }
}
