import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'add_discount_codes_section.dart';
import 'custom_checkbox.dart';

class OnlineOptions extends StatefulWidget {

  final bool discountCode;
  final bool giftCard;
  final Function(bool) onDiscountCodeChanged;
  final Function(bool) onGiftCardChanged;

  const OnlineOptions({super.key, required this.discountCode, required this.giftCard, required this.onDiscountCodeChanged, required this.onGiftCardChanged});

  @override
  State<OnlineOptions> createState() => _OnlineOptionsState();
}


class _OnlineOptionsState extends State<OnlineOptions> {

  late bool discountCode;
  late bool giftCard;

  @override
  void initState() {

    discountCode = widget.discountCode;
    giftCard = widget.giftCard;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Discount Code
        CustomCard(
          height: 52.h,
          child: CustomCheckbox(
              title: "Discount Code",
              isChecked: discountCode,
              onChanged: (isChecked){
                setState(() {
                  discountCode = isChecked!;
                });
                widget.onDiscountCodeChanged( isChecked ?? false );
              }
          )
        ),
        SizedBox(height: 8.h),

        /// Gift Card
        CustomCard(
          height: 52.h,
          child: CustomCheckbox(
              title: "Gift Card",
              isChecked: giftCard,
              onChanged: (isChecked){
                setState(() {
                  giftCard = isChecked!;
                });
                widget.onGiftCardChanged( isChecked ?? false );
              }
          )
        ),
        const SizedBox(height: 25),
        const AddDiscountCodesSection(),
      ],
    );
  }
}
