// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:organization/utils/app_color.dart';
// import 'package:organization/utils/assets_path.dart';
// import '../../../utils/app_size.dart';
//
// class AnalyticsHeader extends StatelessWidget {
//   const AnalyticsHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//            Text(
//             'Analytics',
//             style: GoogleFonts.familjenGrotesk(
//               fontWeight: FontWeight.bold,
//               fontSize: AppSizes.bodyL,
//               color: AppColors.headlineTColor,
//             ),
//           ),
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0x199E9E9E),
//                       spreadRadius: 1,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: 'Last 7 Days',
//                     icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//                    style: GoogleFonts.inter(
//                      fontWeight: FontWeight.w400,
//                      color: AppColors.blackTextColor,
//                      fontSize: 14.sp
//                    ),
//
//                     onChanged: (String? newValue) {
//                       // Handle dropdown change
//                     },
//                     items: <String>['Last 7 Days', 'Last 30 Days', 'This Month', 'Last Month']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           child: Text(value),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 height: 40.h,
//                 width: 40.w,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color:const Color(0x199E9E9E),
//                       spreadRadius: 1,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child:Image.asset(AssetsPath.backIcon,height: 20.h,width: 20.w,),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }