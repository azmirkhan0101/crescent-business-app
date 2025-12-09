import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/assets_path.dart';

import '../../utils/app_color.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor = Colors.black,
    this.inputTextStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.fillColor,
    this.fieldBorderRadius = 12,
    this.fieldBorderColor = Colors.transparent,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLength,
    this.onTap,
    this.isDens = false,
    this.prefixImagePath,
    this.suffixImagePath,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final TextStyle? inputTextStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final double fieldBorderRadius;
  final Color fieldBorderColor;
  final bool isPassword;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final bool? isDens;

  // 🔹 new parameters for image paths
  final String? prefixImagePath;
  final String? suffixImagePath;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.readOnly,
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      cursorColor: widget.cursorColor,
      style:
          widget.inputTextStyle ??
          GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackTextColor,
          ),
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      obscureText: widget.isPassword ? obscureText : false,
      validator: widget.validator,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        isDense: widget.isDens,
        errorMaxLines: 2,
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.hintTextColor,
            ),
        fillColor: AppColors.white,
        filled: true,

        // 🔹 Prefix Image
        prefixIcon: widget.prefixImagePath != null
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: Image.asset(
                  widget.prefixImagePath!,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                ),
              )
            : null,

        // 🔹 Suffix Image / Password toggle
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: toggle,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Image.asset(
                    obscureText ? AssetsPath.eyeIcon : AssetsPath.eyeHideIcon,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : (widget.suffixImagePath != null
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Image.asset(
                        widget.suffixImagePath!,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                      ),
                    )
                  : null),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFFE4E4E4), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFFE4E4E4), width: 1.w),
        ),
        // error border – পুরো outline লাল
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
