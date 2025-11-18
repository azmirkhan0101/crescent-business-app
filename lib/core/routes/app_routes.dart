
import 'package:go_router/go_router.dart';
import 'package:organization/core/routes/route_path.dart';
import 'package:organization/features/auth/otp_verification_screen.dart';
/// Auth & Onboarding Screens
import 'package:organization/features/get_started_screen.dart';
import 'package:organization/features/my_profile/change_password_screen.dart';
import 'package:organization/features/my_profile/my_profile_screen.dart';
import 'package:organization/features/notification/notification_screen.dart';
import 'package:organization/features/on_boarding/category_selection_screen.dart';
import 'package:organization/features/on_boarding/setup_complete_one_screen.dart';
import 'package:organization/features/on_boarding/setup_complete_screen.dart';
import 'package:organization/features/auth/forgot_password_screen.dart';
import 'package:organization/features/auth/reset_password_screen.dart';
import 'package:organization/features/auth/sign_in_screen.dart';
import 'package:organization/features/on_boarding/account_creation_screen.dart';
import 'package:organization/features/on_boarding/business_contact_info_screen.dart';
import 'package:organization/features/on_boarding/business_info_screen.dart';
import 'package:organization/features/on_boarding/store_location_screen.dart';
import 'package:organization/features/on_boarding/upload_logo_screen.dart';
/// Bottom Nav Screens
import 'package:organization/features/home/home_screen.dart';
import 'package:organization/features/analytics/analytics_screen.dart';
import 'package:organization/features/profile/business_profile_screen.dart';
import 'package:organization/features/reward/edit_reward_screen.dart';
import 'package:organization/features/reward/reward_screens.dart';
import 'package:organization/features/reward/tab_reward_screen.dart';
import 'package:organization/features/subscription/subscription_screen.dart';
import 'package:organization/features/terms_condition/terms_condition_screen.dart';
/// Main Nav Wrapper
import '../../features/nav_bar/main_navigation_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/redeem_rewards/on_boarding_store_screen.dart';
import '../../features/redeem_rewards/redeem_scanner_screen.dart';
import '../../features/redeem_rewards/scanner_complete_screen.dart';
import '../../features/reward/create_reward_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RoutesPath.getStarted,
    routes: [
      /// ----------------- Auth & Onboarding -----------------

      GoRoute(
        path: RoutesPath.myProfile,
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: RoutesPath.termsCondition,
        builder: (context, state) => const TermsConditionScreen(),
      ),
      GoRoute(
        path: RoutesPath.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RoutesPath.notification,
        builder: (context, state) => const NotificationScreen(),
      ),

      GoRoute(
        path: RoutesPath.subscription,
        builder: (context, state) => const SubscriptionPage(),
      ),
      GoRoute(
        path: RoutesPath.getStarted,
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: RoutesPath.boardingStore,
        builder: (context, state) => const OnBoardingStoreScreen(),
      ),
      GoRoute(
        path: RoutesPath.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RoutesPath.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RoutesPath.otpVerify,
        builder: (context, state) =>  OtpVerificationScreen(),
      ),
      GoRoute(
        path: RoutesPath.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutesPath.accountCreation,
        builder: (context, state) => const AccountCreationScreen(),
      ),
      GoRoute(
        path: RoutesPath.businessContactInfo,
        builder: (context, state) => const BusinessContactInfoScreen(),
      ),
      GoRoute(
        path: RoutesPath.businessInfo,
        builder: (context, state) => const BusinessInfoScreen(),
      ),
      GoRoute(
        path: RoutesPath.storeLocation,
        builder: (context, state) => const StoreLocationScreen(),
      ),
      GoRoute(
        path: RoutesPath.uploadLogo,
        builder: (context, state) => const UploadLogoScreen(),
      ),
      GoRoute(
        path: RoutesPath.setupComplete,
        builder: (context, state) => BusinessSetupCompleteScreen(),
      ),
      GoRoute(
        path: RoutesPath.setupCompleteOne,
        builder: (context, state) => BusinessSetupCompleteOneScreen(),
      ),
      GoRoute(
        path: RoutesPath.editProfile,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: RoutesPath.categorySelection,
        builder: (context, state) => CategorySelectionScreen(),
      ),
      GoRoute(
        path: RoutesPath.scannerComplete,
        builder: (context, state) => RedeemScannerCompleteScreen(),
      ),
      GoRoute(
        path: RoutesPath.editReward,
        builder: (context, state) => const EditRewardScreen(),
      ),
      GoRoute(
        path: RoutesPath.createReward,
        builder: (context, state) => const CreateRewardScreen(),
      ),
      GoRoute(
        path: RoutesPath.reward,
        builder: (context, state) => const RewardScreens(),
      ),


      /// ----------------- Bottom Navigation -----------------
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: RoutesPath.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RoutesPath.analytics,
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: RoutesPath.redeemScanner,
            builder: (context, state) => const RedeemScannerScreen(),
          ),

          GoRoute(
            path: RoutesPath.tabScreen,
            builder: (context, state) => const TabRewardScreen(),
          ),

          GoRoute(
            path: RoutesPath.businessProfile,
            builder: (context, state) => const BusinessProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
