import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:organization/controller/redeem/redeem_controller.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:vibration/vibration.dart';

import '../../../core/context_extension.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_text.dart';
import 'apply_widget.dart';

class QRCodeWidget extends StatefulWidget {
   QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {

  late TextEditingController textEditingController;

  @override
  void initState() {

    textEditingController = TextEditingController();
    super.initState();
  }

  final RedeemController redeemController = Get.find<RedeemController>();

  final MobileScannerController _controller = MobileScannerController();
  String? scannedCode;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: "Scan QR code",
            color: AppColors.headlineTextColor,
            fontWeight: FontWeight.w600,
            fontSize: isTab ? 16.sp : 24.sp,
            language: true,
          ),
          SizedBox(height: 8.h),
      
          CustomText(text: "Please point the camera at the QR Code",
            color: AppColors.blackTextColor,
            fontWeight: FontWeight.w400,
            fontSize: isTab ? 12.sp : 14.sp,
            language: false,
          ),
          SizedBox(height: 24.h),
          //Scanner Box
          SizedBox(
            width: isTab ? 300 : 190.w,
            height: isTab ? 300 : 190.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  //Live Camera
                  MobileScanner(
                    controller: _controller,
                    onDetect: (capture) async {
                      final barcode = capture.barcodes.first;
                      final String? code = barcode.rawValue;
      
                      if ( code != null && code.isNotEmpty && code != scannedCode && !isProcessing ) {
                        setState((){
                          scannedCode = code;
                          isProcessing = true;
                        });

                        await Future.delayed(Duration(milliseconds: 500));

                        if( await Vibration.hasVibrator() ){
                          Vibration.vibrate(duration: 70);
                        }

                        await Future.delayed(Duration(milliseconds: 800));

                        redeemController.redeemReward(code: code, method: "qr");
                        await _controller.stop();
                        isProcessing = false;
                      }
                    },
                  ),
      
                  //Corner Border Overlay
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _ScannerCornerPainter(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
      
          ///divider text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 75.w,
                child: Divider(color: Color(0xFF777777), thickness: 1.w),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CustomText(text: "Enter code manually",
                  color: AppColors.blackTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: isTab ? 14.sp : 12.sp,
                  language: false,
                ),
              ),
              SizedBox(
                width: 75.w,
                child: Divider(
                    color: Color(0xFF777777),
                    thickness: 1.w
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: isTab ? 120 : 60.h,
            width: 279.w,
            child: CustomCard(
              child: Center(
                child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.mediumStyle.copyWith(
                    color: AppColors.buttonTextColor,
                    fontSize: isTab ? 12.sp : null
                  ),
                  decoration: InputDecoration(
                    hintText: "enter your code here",
                    hintStyle: AppTextStyle.mediumStyle.copyWith(
                      color: AppColors.buttonTextColor.withOpacity(0.6),
                      fontSize: isTab ? 8.sp : null
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ApplyWidget(onPressed: () {
            redeemController.redeemReward(code: textEditingController.text.trim(), method: "static-code");
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {

    textEditingController.dispose();
    unawaited( _controller.dispose());
    super.dispose();
  }
}


/// =============================
/// 🎨 Only Corner Painter
/// =============================
class _ScannerCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8
          .w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 35;

    // 🔹 top-left corner
    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);

    // 🔹 top-right corner
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // 🔹 bottom-left corner
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );

    // 🔹 bottom-right corner
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
