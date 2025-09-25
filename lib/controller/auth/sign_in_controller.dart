// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:organization/core/routes/route_path.dart';
//
// class SignInController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   bool get isValid =>
//       emailController.text.trim().isNotEmpty &&
//           passwordController.text.trim().isNotEmpty;
//
//   void signIn(BuildContext context) {
//     if (!isValid) {
//       Get.snackbar(
//         "Error",
//         "Please enter both email and password",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//            context.push(RoutesPath.home);
//     debugPrint(" Login with ${emailController.text}");
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }
