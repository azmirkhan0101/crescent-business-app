class ApiEndpoints {

  //=======================BASE====================================
  //BASE URL
  static const baseUrl = "https://conduct-macro-band-interaction.trycloudflare.com/api/v1";
  static const imageBaseUrl = "https://conduct-macro-band-interaction.trycloudflare.com/";


  //=======================AUTH====================================
  //LOGIN/SIGNIN
  static const login = "/auth/signin";
  //SIGNUP
  static const signup = "/auth/business-signup";
  //VERIFY SIGNUP OTP
  static const otpSignup = "/auth/verify-signup-otp";
  //RESEND SIGNUP OTP
  static const otpResendSignup = "/auth/send-signup-otp-again";
  //SEND FORGOT PASSWORD OTP
  static const otpForgotPassword = "/auth/forgot-password";
  //RESEND FORGOT PASSWORD OTP
  static const otpResendForgotPassword = "/auth/send-forgot-password-otp-again";
  //VERIFY FORGOT PASSWORD OTP
  static const otpVerifyForgotPassword = "/auth/verify-forgot-password-otp";
  //RESET PASSWORD - NEW PASSWORD
  static const resetPassword = "/auth/reset-password";


  //=======================PROFILE====================================
  //GET PROFILE
  static const getProfile = "/auth/profile";
  //CHANGE PASSWORD - UPDATE PASSWORD
  static const changePassword = "/auth/change-password";
  //DELETE ACCOUNT
  static const deleteAccount = "/auth/delete-account";
  //UPDATE PROFILE
  static const updateProfile = "/business/update-profile";


  //=========================HOME==============================
static const businessOverview = "/business/overview";//HOME SCREEN STATS
static const recentActivity = "/business/recent-activity";//HOME SCREEN RECENT ACTIVITY


//=======================ANALYTICS====================================
  //GET ANALYTICS
  static businessAnalytics({required String timeFilter}){
    return "/business/analytics?timeFilter=$timeFilter";
  }
  //REWARD ANALYTICS BY ID
  static String rewardAnalytics({required String rewardId}){
    return "/business/analytics/$rewardId";
  }

  //========================REWARD===============================
  //CREATE REWARD - INSTORE AND ONLINE
  static const createRewardInStore = "/rewards"; //SAME FOR ONLINE
  static String getAllRewards({required String status, String search = ""}){
    //TODO: CONTROL STATUS, PAGE, LIMIT FROM CONTROLLER
    if( search.isEmpty ){//NO SEARCH
      return "/rewards/business/my-rewards?status=$status&search&page=1&limit=10";
    }else{//SEARCH
      return "/rewards/business/my-rewards?status=$status&search=$search&page=1&limit=10";
    }
  }
  static String updateRewardStatus({required String rewardID}){
    return "/rewards/$rewardID/status";
  }
  static const deleteReward = "/rewards/";//BUSINESS ID WILL BE PASSED FROM CONTROLLER IN PARAMETER
}
