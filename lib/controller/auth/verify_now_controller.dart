import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';

import '../../utils/api_endpoints.dart';

class VerifyNowController extends GetxController{

  final storage = GetStorage();

  String? email(){
    return storage.read( emailKey );
  }

  //VERIFY NOW CLICK -> SEND SIGNUP OTP ( SAME AS RESEND SIGNUP OTP )
  void sendVerificationOtp() async{

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendSignup );
      Map<String, String> payLoad = {
        "email": email()!
      };
      http.Response response = await http.post( uri, body: payLoad );

      print("Email: ${email()}");
      print("Status code: ${response.statusCode}");
      print("Response ${response.body}");
      if( response.statusCode == 200 ){
        Get.snackbar(
            "OTP sent!",
            "an OTP has been sent to your email."
        );
        Map<String, dynamic> arguments = {
          emailKey : email()!,
          isSignupKey : true
        };
        Get.offNamed( AppRoutes.otpVerify, arguments: arguments );
      }else if( response.statusCode == 400 ){
        Get.snackbar(
            "OTP already sent",
            "Check your mail and enter the otp."
        );
        Map<String, dynamic> arguments = {
          emailKey : email()!,
          isSignupKey : true
        };
        Get.offNamed( AppRoutes.otpVerify, arguments: arguments );
      }else{
        print("Try errorrrrrr");
        showSnackBar(
            title: "Error!",
            message: "Something went wrong. Please try again,",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      print("Error: ${e}");
      showSnackBar(
          title: "Error!",
          message: "Something went wrong. Please try again,",
          backgroundColor: AppColors.errorRed
      );
    }


  }

  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );
  }

}