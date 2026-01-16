//SHOW SNACKBAR
import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../utils/app_color.dart';

showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
  Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor
  );
}