import 'package:get/get.dart';
import 'package:organization/features/auth/forgot_password_screen.dart';
import 'package:organization/features/auth/login_screen.dart';
import 'package:organization/features/auth/otp_verification_screen.dart';
import 'package:organization/features/auth/reset_password_screen.dart';
import 'package:organization/features/get_started_screen.dart';
import 'package:organization/features/nav_bar/main_navigation_screen.dart';
import 'package:organization/features/notification/notification_screen.dart';
import 'package:organization/features/on_boarding/account_creation_screen.dart';
import 'package:organization/features/on_boarding/business_contact_info_screen.dart';
import 'package:organization/features/on_boarding/business_info_screen.dart';
import 'package:organization/features/on_boarding/category_selection_screen.dart';
import 'package:organization/features/on_boarding/setup_complete_screen.dart';
import 'package:organization/features/on_boarding/store_location_screen.dart';
import 'package:organization/features/on_boarding/upload_logo_screen.dart';
import 'package:organization/features/on_boarding/verify_now_screen.dart';
import 'package:organization/features/profile/change_password_screen.dart';
import 'package:organization/features/profile/profile_settings_screen.dart';
import 'package:organization/features/reward/edit_reward_screen.dart';
import 'package:organization/features/reward/reward_screen.dart';
import 'package:organization/features/splash_screen.dart';
import 'package:organization/features/subscription/subscription_screen.dart';
import 'package:organization/features/terms_condition/terms_condition_screen.dart';

import '../../features/profile/edit_profile_screen.dart';
import '../../features/redeem_rewards/on_boarding_store_screen.dart';
import '../../features/redeem_rewards/scanner_complete_screen.dart';
import '../../features/reward/create_reward_screen.dart';

part 'app_routes.dart';

class AppPages {

  static final pages = [

    GetPage(
        name: AppRoutes.splashScreen,
        page: (){
          return SplashScreen();
        }
    ),
    GetPage(
        name: AppRoutes.mainNav,
        page: (){
          return MainNavigationScreen();
        }
    ),
    GetPage(
        name: AppRoutes.profileSettings,
        page: (){
          return ProfileSettingsScreen();
        }
    ),
    GetPage(
        name: AppRoutes.termsCondition,
        page: (){
          return TermsConditionScreen();
        }
    ),
    GetPage(
        name: AppRoutes.changePassword,
        page: (){
          return ChangePasswordScreen();
        }
    ),
    GetPage(
        name: AppRoutes.notification,
        page: (){
          return NotificationScreen();
        }
    ),
    GetPage(
        name: AppRoutes.subscription,
        page: (){
          return SubscriptionPage();
        }
    ),
    GetPage(
        name: AppRoutes.getStarted,
        page: (){
          return GetStartedScreen();
        }
    ),
    GetPage(
        name: AppRoutes.boardingStore,
        page: (){
          return OnBoardingStoreScreen();
        }
    ),
    GetPage(
        name: AppRoutes.logIn,
        page: (){
          return LoginScreen();
        }
    ),
    GetPage(
        name: AppRoutes.resetPassword,
        page: (){
          return ResetPasswordScreen();
        }
    ),
    GetPage(
        name: AppRoutes.verifyNow,
        page: (){
          return VerifyNowScreen();
        }
    ),
    GetPage(
        name: AppRoutes.otpVerify,
        page: (){
          return OtpVerificationScreen();
        }
    ),
    GetPage(
        name: AppRoutes.forgotPassword,
        page: (){
          return ForgotPasswordScreen();
        }
    ),
    GetPage(
        name: AppRoutes.accountCreation,
        page: (){
          return AccountCreationScreen();
        }
    ),
    GetPage(
        name: AppRoutes.businessContactInfo,
        page: (){
          return BusinessContactInfoScreen();
        }
    ),
    GetPage(
        name: AppRoutes.businessInfo,
        page: (){
          return BusinessInfoScreen();
        }
    ),
    GetPage(
        name: AppRoutes.storeLocation,
        page: (){
          return StoreLocationScreen();
        }
    ),
    GetPage(
        name: AppRoutes.uploadLogo,
        page: (){
          return UploadLogoScreen();
        }
    ),
    GetPage(
        name: AppRoutes.setupComplete,
        page: (){
          return BusinessSetupCompleteScreen();
        }
    ),
    GetPage(
        name: AppRoutes.editProfile,
        page: (){
          return EditProfileScreen();
        }
    ),
    GetPage(
        name: AppRoutes.categorySelection,
        page: (){
          return CategorySelectionScreen();
        }
    ),
    GetPage(
        name: AppRoutes.scannerComplete,
        page: (){
          return RedeemScannerCompleteScreen();
        }
    ),
    GetPage(
        name: AppRoutes.editReward,
        page: (){
          return EditRewardScreen();
        }
    ),
    GetPage(
        name: AppRoutes.createReward,
        page: (){
          return CreateRewardScreen();
        }
    ),
    GetPage(
        name: AppRoutes.reward,
        page: (){
          return RewardScreen();
        }
    ),

  ];
      /// ----------------- Bottom Navigation -----------------
      // ShellRoute(
      //   builder: (context, state, child) {
      //     return MainNavigationScreen(child: child);
      //   },
      //   routes: [
      //     GoRoute(
      //       path: RoutesPath.home,
      //       builder: (context, state) => const HomeScreen(),
      //     ),
      //     GoRoute(
      //       path: RoutesPath.analytics,
      //       builder: (context, state) => const AnalyticsScreen(),
      //     ),
      //     GoRoute(
      //       path: RoutesPath.redeemScanner,
      //       builder: (context, state) => const RedeemScannerScreen(),
      //     ),
      //
      //     GoRoute(
      //       path: RoutesPath.tabScreen,
      //       builder: (context, state) => const TabRewardScreen(),
      //     ),
      //
      //     GoRoute(
      //       path: RoutesPath.businessProfile,
      //       builder: (context, state) => const BusinessProfileScreen(),
      //     ),
      //   ],
      // )
}
