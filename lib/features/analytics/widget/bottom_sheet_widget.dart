import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';

class BottomSheetWidget extends StatefulWidget {

  final Function(bool) onExportClick;
  const BottomSheetWidget({
    super.key,
    required this.onExportClick
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      height: isTab ? 450 : 340.h,
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
              Text("Export data", style: AppTextStyle.cardTextStyle.copyWith(fontSize: isTab ? 10.sp : null)),
              GestureDetector(
                onTap: (){
                  Get.back(closeOverlays: true);
                },
                child: Icon(Icons.close, size: isTab ? 40 : 20.w),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "Select format for the data you want to export",
            style: AppTextStyle.mediumStyle.copyWith(fontSize: isTab ? 8.sp : null),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildOptionCard(0, "Export .CSV", AssetsPath.bottomS1Icon, isTab),
              SizedBox(width: isTab ? 20 : 16.w),
              _buildOptionCard(1, "Export .PDF", AssetsPath.bottomS2Icon, isTab),
            ],
          ),
          SizedBox(height: 16.h),
          Center(
            child: CustomButton(
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: isTab ? 10.sp : 18.sp,
                fontWeight: FontWeight.w700,
              ),
              onPressed: () {
                //isPdf
                widget.onExportClick( selectedIndex == 1 );
              },
              text: "Export",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String title, String iconPath, bool isTab) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all( isTab ? 8 : 8.w),
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
                    padding: EdgeInsets.all( isTab ? 10 : 18.w),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0x26C08FFF) : Color(0xFFF7F7F7),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(iconPath, height: isTab ? 40 : 18.h, width: isTab ? 40 : 16.w),
                  ),
                  SizedBox(height: 8.h),
                  Text(title, style: AppTextStyle.cardTextStyle.copyWith( fontSize: isTab ? 8.sp : null)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
