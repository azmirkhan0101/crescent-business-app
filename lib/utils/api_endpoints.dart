class ApiEndpoints{

  static const baseUrl = "http://10.10.20.42:5000/api/v1";
  static const login = "/auth/signin";
  static const signup = "/auth/business-signup";
  static const otpSignup = "/auth/verify-signup-otp";
  static const otpResendSignup = "/auth/send-signup-otp-again";
  static const otpForgotPassword = "/auth/forgot-password";
  static const otpVerifyForgotPassword = "/auth/verify-forgot-password-otp";
  static const resetPassword = "/auth/reset-password";
}