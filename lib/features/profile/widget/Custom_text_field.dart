// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:organization/utils/app_color.dart';
// import 'package:organization/utils/app_text_styles.dart';
//
// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final Icon? prefixIcon;
//   final int maxLines;
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;
//   final bool readOnly;
//   final double? width; // ✅ optional width
//
//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     this.prefixIcon,
//     this.maxLines = 1,
//     this.validator,
//     this.controller,
//     this.readOnly = false,
//     this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width ?? 343.w, // ✅ ডিফল্ট width
//       // height বাদ দেওয়া হলো → maxLines অনুযায়ী auto height হবে
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color(0xFFE4E4E4),
//           width: 1,
//         ),
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         readOnly: readOnly,
//         validator: validator,
//         style: AppTextStyle.mediumStyle.copyWith(
//           fontWeight: FontWeight.w500,
//           color: AppColors.blackTextColor,
//         ),
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: prefixIcon,
//           contentPadding: const EdgeInsets.all(12),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
