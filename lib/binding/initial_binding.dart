import 'package:get/get.dart';
import 'package:organization/controller/analytics/analytics_controller.dart';
import 'package:organization/controller/auth/login_controller.dart';
import 'package:organization/controller/auth/setup_complete_controller.dart';
import 'package:organization/controller/auth/verify_now_controller.dart';
import 'package:organization/controller/home/home_controller.dart';
import 'package:organization/controller/nav/main_nav_controller.dart';import 'package:organization/controller/profile/business_profile_controller.dart';
import 'package:organization/controller/profile/profile_settings_controller.dart';
import 'package:organization/controller/profile/terms_controller.dart';
import 'package:organization/controller/redeem/redeem_controller.dart';
import 'package:organization/controller/reward/edit_reward_controller.dart';
import 'package:organization/controller/reward/reward_controller.dart';
import 'package:organization/controller/subscription/subscription_controller.dart';
import '../controller/auth/sign_up_controller.dart';
import '../controller/auth/forgot_pass_controller.dart';
import '../controller/auth/otp_verification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut((){
      return MainNavController();
    }, fenix: true);

    Get.lazyPut((){
      return HomeController();
    }, fenix: true);

    Get.lazyPut((){
      return AnalyticsController();
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

    Get.lazyPut<ProfileSettingsController>((){
      return ProfileSettingsController();
    },fenix: true,);

    Get.lazyPut<VerifyNowController>((){
      return VerifyNowController();
    },fenix: true,);

    Get.lazyPut<OtpVerificationController>((){
      return OtpVerificationController();
    }, fenix: true,);

    Get.lazyPut<RewardController>((){
      return RewardController();
    }, fenix: true,);

    Get.lazyPut<BusinessProfileController>((){
      return BusinessProfileController();
    }, fenix: true,);

    Get.lazyPut<EditRewardController>((){
      return EditRewardController();
    }, fenix: true,);

    Get.lazyPut<RedeemController>((){
      return RedeemController();
    }, fenix: true,);

    Get.lazyPut<TermsController>((){
      return TermsController();
    }, fenix: true,);

    Get.lazyPut<SubscriptionController>((){
      return SubscriptionController();
    }, fenix: true,);

  }
}
