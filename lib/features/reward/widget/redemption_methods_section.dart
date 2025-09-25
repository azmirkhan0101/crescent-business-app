import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/text_field_title_widget.dart';
import 'in_store_options_widget.dart';
import 'online_options_widget.dart';

class RedemptionMethodsSection extends StatefulWidget {
  const RedemptionMethodsSection({super.key});

  @override
  State<RedemptionMethodsSection> createState() =>
      _RedemptionMethodsSectionState();
}

class _RedemptionMethodsSectionState extends State<RedemptionMethodsSection> {
  bool isInStoreSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Select Redemption Methods"),
        const SizedBox(height: 10),

        // 🔹 In-Store / Online Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              children: [
                // In-Store button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isInStoreSelected ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: () =>
                          setState(() => isInStoreSelected = true),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'In-Store',
                        style: TextStyle(
                          color: isInStoreSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Online button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isInStoreSelected ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: () =>
                          setState(() => isInStoreSelected = false),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Online',
                        style: TextStyle(
                          color: !isInStoreSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 15.h),

        // 🔹 Show widgets depending on tab
        isInStoreSelected ? const InStoreOptions() : const OnlineOptions(),
      ],
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:organization/features/widgets/custom_card_widget.dart';
// import 'package:organization/utils/app_color.dart';
//
// import '../../widgets/text_field_title_widget.dart';
//
// class RedemptionMethodsSection extends StatefulWidget {
//   const RedemptionMethodsSection({Key? key}) : super(key: key);
//
//   @override
//   State<RedemptionMethodsSection> createState() =>
//       _RedemptionMethodsSectionState();
// }
//
// class _RedemptionMethodsSectionState extends State<RedemptionMethodsSection> {
//   bool isInStoreSelected = true;
//   bool isDiscountCodeChecked = true;
//   bool isGiftCardChecked = true;
//   bool isStaticCodeChecked = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFieldTitleWidget(text: "Select Redemption Methods"),
//         const SizedBox(height: 10),
//
//         // 🔹 In-Store / Online button row
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Padding(
//             padding:   EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
//                     decoration: BoxDecoration(
//                       color: isInStoreSelected ? Colors.black : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: TextButton(
//                       onPressed: () => setState(() => isInStoreSelected = true),
//                       style: TextButton.styleFrom(
//                         backgroundColor:
//                             Colors.transparent, // ✅ container handles bg
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                       child: Text(
//                         'In-Store',
//                         style: TextStyle(
//                           color: isInStoreSelected ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14.sp
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 2,
//                       vertical: 1,
//                     ),
//                     decoration: BoxDecoration(
//                       color: !isInStoreSelected ? Colors.black : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: TextButton(
//                       onPressed: () => setState(() => isInStoreSelected = false),
//                       style: TextButton.styleFrom(
//                         backgroundColor:
//                             Colors.transparent, // ✅ container handles bg
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                       child: Text(
//                         'Online',
//                         style: TextStyle(
//                           color: !isInStoreSelected ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14.sp
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//          //in store tab
//          Column(
//            children: [
//              SizedBox(height: 15.h),
//
//                      // 🔹 Checkbox ListTiles
//                      CustomCard(
//               alignment: Alignment.center,
//               height: 52.h,
//               child: _buildCheckboxListTile(
//                 'Discount Code',
//                 isDiscountCodeChecked,
//                 (val) => setState(() => isDiscountCodeChecked = val ?? false),
//               ),
//                      ),
//
//
//                      SizedBox(height: 8.h),
//
//                      CustomCard(
//               alignment: Alignment.center,
//               height: 52.h,
//               child: _buildCheckboxListTile(
//                 'Gift Card',
//                 isGiftCardChecked,
//                 (val) => setState(() => isGiftCardChecked = val ?? false),
//               ),
//                      ),
//
//                      SizedBox(height: 8.h),
//
//                      CustomCard(
//               alignment: Alignment.center,
//               height: 52.h,
//               child: _buildCheckboxListTile(
//                 'Static Code',
//                 isStaticCodeChecked,
//                     (val) => setState(() => isStaticCodeChecked = val ?? false),
//               ),
//                      ),
//            ],
//          ),
//       ],
//     );
//   }
//
//   Widget _buildCheckboxListTile(
//       String title,
//       bool isChecked,
//       Function(bool?) onChanged,
//       ) {
//     return Align(
//       alignment: Alignment.center, // ✅ সবসময় center এ রাখবে
//       child: CheckboxListTile(
//         title: Text(
//           title,
//           style:  TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14.sp
//           ),
//         ),
//         value: isChecked,
//         onChanged: onChanged,
//         activeColor: AppColors.primaryColor,
//         checkColor: Colors.white,
//         controlAffinity: ListTileControlAffinity.leading,
//         dense: true,
//         visualDensity: VisualDensity(horizontal: -4, vertical: -4), // ✅ আরও compact
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }
//
//
//
//
//
//
//
//
//
//
// }
