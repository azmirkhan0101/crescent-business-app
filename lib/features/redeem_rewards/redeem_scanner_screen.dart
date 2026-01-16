import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/redeem/redeem_controller.dart';
import 'package:organization/features/redeem_rewards/widgets/qr_code_redeem.dart';
import 'package:organization/features/redeem_rewards/widgets/static_code_redeem.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

class RedeemScannerScreen extends StatefulWidget {
  const RedeemScannerScreen({super.key});

  @override
  State<RedeemScannerScreen> createState() => _RedeemScannerScreenState();
}

class _RedeemScannerScreenState extends State<RedeemScannerScreen> {

  final RedeemController controller = Get.find<RedeemController>();
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    QRCodeWidget(),
    //NFCWidget(),
    StaticCodeWidget(),
  ];


  final List<LinearGradient> _gradients = [
    const LinearGradient(
      colors: [
        Color(0x0AD1FF43), // 4%
        Color(0x0FD1FF43), // 6%
        Color(0xB2D1FF43), // 70%
      ]
      , // QR Gradient (Blue)
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
    const LinearGradient(
      colors: [
        Color(0x0DE6C8FF), // 5%
        Color(0x1AE6C8FF), // 10%
        Color(0xFFE6C8FF), // 100%
      ]
      , // NFC Gradient (Green)
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
    const LinearGradient(
      colors: [
        Color(0x26FF43A1), // 15%
        Color(0x33FF43A1), // 20%
        Color(0x73FF43A1), // 45%
      ], // Static Code Gradient (Orange)
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: _gradients[_selectedIndex],
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: "Redeem",
                              color: AppColors.blackTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              language: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // Tab Content
                        Center(child: _tabs[_selectedIndex]),
                        const Spacer(),
                        SizedBox(height: 25.h),
                        /// Custom TabBar
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0x33FFFFFF),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              _buildTabButton("QR Code", 0),
                              //_buildTabButton("NFC", 1),
                              _buildTabButton("Static Code", 1),
                            ],
                          ),
                        ),
                        SizedBox(height: 90.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //Tab Button
  Widget _buildTabButton(String text, int index) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            controller.isStaticCodeInvalid.value = false;
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
