import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/reward/widget/custom_checkbox.dart';

import '../../../core/context_extension.dart';
import '../../widgets/custom_card_widget.dart';
import '../../widgets/text_field_title_widget.dart';
import 'online_options_widget.dart';

class RedemptionMethodsSection extends StatefulWidget {


  final Function(bool) onTabChanged;
  final bool qrCode;
  final bool nfcTap;
  final bool staticCode;
  final bool discountCode;
  final bool giftCard;
  //ONLINE
  final String? fileName;
  final VoidCallback onPickFile;
  final VoidCallback onDelete;
  final Function(bool) onQRCodeChanged;
  final Function(bool) onNfcTapChanged;
  final Function(bool) onStaticCodeChanged;
  final Function(bool) onDiscountCodeChanged;
  final Function(bool) onGiftCardChanged;

  const RedemptionMethodsSection({
    super.key,
    required this.onTabChanged,
    required this.qrCode,
    required this.nfcTap,
    required this.staticCode,
    required this.onQRCodeChanged,
    required this.onNfcTapChanged,
    required this.onStaticCodeChanged,
    required this.discountCode,
    required this.giftCard,
    required this.onDiscountCodeChanged,
    required this.onGiftCardChanged,
    this.fileName,
    required this.onPickFile,
    required this.onDelete,
  });

  @override
  State<RedemptionMethodsSection> createState() =>
      _RedemptionMethodsSectionState();
}

class _RedemptionMethodsSectionState extends State<RedemptionMethodsSection> {

  bool isInStoreSelected = true;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Select Redemption Methods"),
        const SizedBox(height: 10),

        //In-Store / Online TabsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              children: [
                // In-Store buttonNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isInStoreSelected ? Colors.black : Colors
                          .grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: (){
                        setState((){
                          isInStoreSelected = true;
                          widget.onTabChanged( true );
                        });
                      },
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
                          fontSize: isTab ? 10.sp : 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Online buttonNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isInStoreSelected ? Colors.black : Colors
                          .grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: (){
                        setState((){
                          isInStoreSelected = false;
                          widget.onTabChanged( false );
                        });
                      },
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
                          fontSize: isTab ? 10.sp : 14.sp,
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
            inStoreOptions(isTab)
            : OnlineOptions(
          fileName: widget.fileName,
          onPickFile: widget.onPickFile,
          onDelete: widget.onDelete,
          discountCode: widget.discountCode,
          giftCard: widget.giftCard,
          onDiscountCodeChanged: (bool isChecked) {
            widget.onDiscountCodeChanged( isChecked );
          }, onGiftCardChanged: (bool isChecked) {
          widget.onGiftCardChanged( isChecked );
        },
        ),
      ],
    );
  }

  //INSTORE OPTIONS
  inStoreOptions(bool isTab) {
    return Column(
      children: [
        CustomCard(
            height: isTab ? 80 : 52.h,
            child: CustomCheckbox(
                title: "QR Code",
                isChecked: widget.qrCode,
                onChanged: (isChecked){
                  widget.onQRCodeChanged( isChecked ?? false );
                }
            )
        ),
        SizedBox(height: 8.h),
        // CustomCard(
        //   height: isTab ? 80 : 52.h,
        //   child: CustomCheckbox(
        //       title: "NFC Tap",
        //       isChecked: widget.nfcTap,
        //       onChanged: (isChecked){
        //         widget.onNfcTapChanged( isChecked ?? false );
        //       }
        //   )
        // ),
        // SizedBox(height: 8.h),
        CustomCard(
          height: isTab ? 80 : 52.h,
          child: CustomCheckbox(
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

}