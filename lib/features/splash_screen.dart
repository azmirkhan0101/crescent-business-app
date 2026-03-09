import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

enum AuthStatus {
  loggedInAndVerified,
  loggedInNotVerified,
  loggedOut,
}

class SplashScreen extends StatelessWidget {

  final storage = GetStorage();

  Future<AuthStatus> checkAuthStatus() async {

    await Future.delayed(const Duration(milliseconds: 1500));

    // Read the token and verification status
    final String? token = storage.read( accessTokenKey );
    print("Tokennnnnnnnnnnnnnnnnnn: $token");
    //final String? email = storage.read( emailKey );
    final bool verificationRequired = storage.read( requireVerificationKey ) ?? false;

    // If token is null or empty, the user is logged out (or never logged in)
    if ( token == null || token.isEmpty ) {//NO TOKEN -> LOGGED OUT OR REQUIRE VERIFICATION
      if( verificationRequired ){
        return AuthStatus.loggedInNotVerified;
      }else{
        return AuthStatus.loggedOut;
      }
    }else{//TOKEN FOUND -> LOGGED IN AND VERIFIED
      return AuthStatus.loggedInAndVerified;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder<AuthStatus>(
        future: checkAuthStatus(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(
              child: Image.asset(
                Assets.images.logo1024.keyName,
                height: 212.h,
                width: 212.w,
                fit: BoxFit.cover,
              ),
            );
          }

          // The status is resolved, now perform the navigation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final AuthStatus status = snapshot.data!;

            switch(status) {
              case AuthStatus.loggedInAndVerified:
                print("Logged in and verified");
              //VALID TOKEN & VERIFIED -> GO TO MAIN NAV
                Get.offNamed(AppRoutes.mainNav);
                break;
              case AuthStatus.loggedInNotVerified:
              //NOT VERIFIED -> GO TO VERIFY NOW
                Get.offNamed(AppRoutes.verifyNow);
                break;
              default:
              //NO TOKEN -> GO TO GET STARTED
                Get.offNamed(AppRoutes.getStarted);
                break;
            }
          });

          // Return a blank widget while navigation occurs
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
