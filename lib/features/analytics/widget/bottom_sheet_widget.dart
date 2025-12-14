import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      height: 340.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Export data", style: AppTextStyle.cardTextStyle),
              GestureDetector(
                onTap: (){
                  Get.back(closeOverlays: true);
                },
                child: Icon(Icons.close, size: 20.w),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "Select format for the data you want to export",
            style: AppTextStyle.mediumStyle,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildOptionCard(0, "Export .CSV", AssetsPath.bottomS1Icon),
              SizedBox(width: 16.w),
              _buildOptionCard(1, "Export .PDF", AssetsPath.bottomS2Icon),
            ],
          ),
          SizedBox(height: 16.h),
          Center(
            child: CustomButton(
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              onPressed: () {},
              text: "Export",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String title, String iconPath) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedIndex = null; // deselect if already selected
            } else {
              selectedIndex = index; // select new
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isSelected ? Color(0x26C08FFF) : AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color(0xFFEDEDED),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x05000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomAssetsImage(
                    assetsPath: isSelected
                        ? AssetsPath.radioSelected
                        : AssetsPath.radioUnselected,
                    height: isSelected ? 14.h : 10.h,
                    width: isSelected ? 14.h : 10.h,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0x26C08FFF) : Color(0xFFF7F7F7),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(iconPath, height: 18.h, width: 16.w),
                  ),
                  SizedBox(height: 8.h),
                  Text(title, style: AppTextStyle.cardTextStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
