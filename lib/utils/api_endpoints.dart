class ApiEndpoints {

  //=======================BASE====================================
  //BASE URL
  static const baseUrl =
      "https://ann-passage-mpegs-watching.trycloudflare.com/api/v1";
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
  static const businessAnalytics = "/business/analytics?timeFilter=last_7_days";//TODO: PASS TIME FILTER PARAMETER FROM CONTROLLER
  //REWARD ANALYTICS STATS
  static const rewardAnalytics = "/business/analytics/";//TODO: PASS REWARD ID FROM CONTROLLER
  //========================REWARD===============================
  //CREATE REWARD - INSTORE AND ONLINE
  static const createRewardInStore = "/rewards"; //SAME FOR ONLINE
  static const getAllRewards =
      "/rewards/business/my-rewards?status=active&search&page=1&limit=10"; //TODO: CONTROL STATUS, PAGE, LIMIT FROM CONTROLLER
  static const deleteReward = "/rewards/";//BUSINESS ID WILL BE PASSED FROM CONTROLLER IN PARAMETER
}
