class ApiEndpoints{

  //BACKEND DEVELOPER BASEURL
  //static const baseUrl = "http://10.10.20.42:5000/api/v1";
  //MY DESKTOP LOCAL SERVER
  //static const baseUrl = "http://192.168.56.1:5000/api/v1";
  //static const baseUrl = "https://dauntless-cathey-telial.ngrok-free.dev/api/v1";
  static const baseUrl = "https://samples-warned-calls-forwarding.trycloudflare.com/api/v1";
  static const getProfile = "/auth/profile";
  static const login = "/auth/signin";
  static const signup = "/auth/business-signup";
  static const otpSignup = "/auth/verify-signup-otp";
  static const otpResendSignup = "/auth/send-signup-otp-again";
  static const otpForgotPassword = "/auth/forgot-password";
  static const otpResendForgotPassword = "/auth/send-forgot-password-otp-again";
  static const otpVerifyForgotPassword = "/auth/verify-forgot-password-otp";
  static const resetPassword = "/auth/reset-password";
  static const updateProfile = "/business/update-profile";
  static const rewardAnalyticsStats = "/rewards/analytics/stats";
  static const createRewardInStore = "/rewards";
  //static const createRewardOnline = "/api/rewards";cloudflared tunnel --url http://localhost:5000
}