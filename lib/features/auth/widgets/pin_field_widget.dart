import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinFieldWidget extends StatelessWidget {
  const PinFieldWidget({
    super.key,
    required this.controller,
    required this.length,
    this.onChanged,
    this.onCompleted, required this.isTab,
  });

  final TextEditingController controller;
  final int length;
  final bool isTab;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      textStyle: TextStyle(fontSize: isTab ? 12.sp : null),
      appContext: context,
      controller: controller,
      length: length,
      obscureText: false,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 200),
      enableActiveFill: true,
      autoDisposeControllers: false,

      // ✅ pin theme
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: isTab ? 80 : 40,
        fieldWidth: isTab ? 80 : 40,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: const Color(0xFFE4E4E4),
        inactiveColor: const Color(0xFFE4E4E4),
        selectedColor: const Color(0xFFE4E4E4),

        // // 🔥 gap between fields
        // fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8.w),
      ),

      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
