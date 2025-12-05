import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../widgets/custom_card_widget.dart';
import '../../widgets/text_field_title_widget.dart';
import 'online_options_widget.dart';

class RedemptionMethodsSection extends StatefulWidget {

  final bool qrCode;
  final bool nfcTap;
  final bool staticCode;
  final Function(bool) onQRCodeChanged;
  final Function(bool) onNfcTapChanged;
  final Function(bool) onStaticCodeChanged;

  const RedemptionMethodsSection({
    super.key,
    required this.qrCode,
    required this.nfcTap,
    required this.staticCode,
    required this.onQRCodeChanged,
    required this.onNfcTapChanged,
    required this.onStaticCodeChanged,
  });

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
                      color: isInStoreSelected ? Colors.black : Colors
                          .grey[200],
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
                          color: isInStoreSelected ? Colors.white : Colors
                              .black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Online button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isInStoreSelected ? Colors.black : Colors
                          .grey[200],
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
                          color: !isInStoreSelected ? Colors.white : Colors
                              .black,
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
        isInStoreSelected ?
            inStoreOptions()
            : const OnlineOptions(),
      ],
    );
  }

  //
  inStoreOptions() {
    return Column(
      children: [
        CustomCard(
            height: 52.h,
            child: buildCheckboxRow(
                title: "QR Code",
                isChecked: widget.qrCode,
                onChanged: (isChecked){
                  widget.onQRCodeChanged( isChecked ?? false );
                }
            )
        ),
        SizedBox(height: 8.h),
        CustomCard(
          height: 52.h,
          child: buildCheckboxRow(
              title: "NFC Tap",
              isChecked: widget.nfcTap,
              onChanged: (isChecked){
                widget.onNfcTapChanged( isChecked ?? false );
              }
          )
        ),
        SizedBox(height: 8.h),
        CustomCard(
          height: 52.h,
          child: buildCheckboxRow(
              title: "Static Code",
              isChecked: widget.staticCode,
              onChanged: (isChecked){
                widget.onStaticCodeChanged( isChecked ?? false );
              }
          )
        ),
      ],
    );
  }

  //CHECKBOX
  Widget buildCheckboxRow({required String title,
    required bool isChecked,
    required Function(bool?) onChanged
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          checkColor: Colors.white,
          materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
      ],
    );
  }

}