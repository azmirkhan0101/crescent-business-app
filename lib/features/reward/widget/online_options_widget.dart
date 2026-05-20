import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';

import 'add_discount_codes_section.dart';
import 'custom_checkbox.dart';

class OnlineOptions extends StatefulWidget {

  final VoidCallback onPickFile;      // When user taps upload
  final VoidCallback onDelete;        // When user taps delete
  final String? fileName;
  final bool discountCode;
  final bool giftCard;
  final Function(bool) onDiscountCodeChanged;
  final Function(bool) onGiftCardChanged;

  const OnlineOptions({
    super.key,
    required this.discountCode,
    required this.giftCard,
    required this.onDiscountCodeChanged,
    required this.onGiftCardChanged,
    required this.onPickFile,
    required this.onDelete,
    this.fileName,
  });

  @override
  State<OnlineOptions> createState() => _OnlineOptionsState();
}


class _OnlineOptionsState extends State<OnlineOptions> {

  //late bool discountCode;
  //late bool giftCard;

  @override
  void initState() {

    //discountCode = widget.discountCode;
    //giftCard = widget.giftCard;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Column(
      children: [
        /// Discount Code
        CustomCard(
          height: isTab ? 80 : 52.h,
          child: CustomCheckbox(
              title: "Discount Code",
              isChecked: widget.discountCode,
              onChanged: (isChecked){
                widget.onDiscountCodeChanged( isChecked ?? false );
              }
          )
        ),
        SizedBox(height: 8.h),

        /// Gift Card
        CustomCard(
          height: isTab ? 80 : 52.h,
          child: CustomCheckbox(
              title: "Gift Card",
              isChecked: widget.giftCard,
              onChanged: (isChecked){
                widget.onGiftCardChanged( isChecked ?? false );
              }
          )
        ),
        SizedBox(height: 25),
        AddDiscountCodesSection(
          fileName: widget.fileName,
          onPickFile: widget.onPickFile,
          onDelete: widget.onDelete,
        ),
      ],
    );
  }

}
