import 'package:get/get.dart';
import 'package:organization/controller/main_navigation_screen_controller/main_navigation_screen_controller.dart';
import '../controller/auth/sign_in_controller.dart';
import '../controller/auth/forgot_pass_controller.dart';
import '../controller/auth/otp_verification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut((){
      return MainNavigationScreenController();
    }, fenix: true);

    Get.lazyPut<SignInController>((){
      return SignInController();
    }, fenix: true);

    Get.lazyPut<ForgotPasswordController>((){
      return ForgotPasswordController();
    },fenix: true,);

    Get.lazyPut<OtpVerificationController>((){
      return OtpVerificationController();
    }, fenix: true,);
  }
}
