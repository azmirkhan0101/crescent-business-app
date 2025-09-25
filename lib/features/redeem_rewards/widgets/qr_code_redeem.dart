import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../widgets/custom_text.dart';
import 'apply_widget.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final MobileScannerController _controller = MobileScannerController();
  String? scannedCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(text: "Scan QR code",
          color: AppColors.headlineTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
          language: true,
        ),

        // Text(
        //   "Scan QR code",
        //   style: AppTextStyle.headlineLStyle.copyWith(
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        SizedBox(height: 8.h),

        CustomText(text: "Please point the camera at the QR Code",
          color: AppColors.blackTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          language: false,
        ),

        // Text(
        //   "Please point the camera at the QR Code",
        //   style: AppTextStyle.mediumStyle,
        // ),
        SizedBox(height: 24.h),
        // ✅ Scanner Box
        SizedBox(
          width: 200.h,
          height: 200.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // 📷 Live Camera
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) async {
                    final barcode = capture.barcodes.first;
                    final String? code = barcode.rawValue;

                    if (code != null &&
                        code.isNotEmpty &&
                        code != scannedCode) {
                      setState(() => scannedCode = code);
                      await _controller.stop(); // stop after scan
                    }
                  },
                ),

                // 🎨 Corner Border Overlay
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
              child:         CustomText(text: "Enter code manually",
                color: AppColors.blackTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                language: false,
              ),


              // Text(
              //   "Enter code manually",
              //   style: AppTextStyle.mediumStyle.copyWith(
              //     fontSize: 12.sp,
              //     color: AppColors.blackTextColor,
              //   ),
              // ),
            ),
            SizedBox(
              width: 75.w, // 👈 fixed width
              child: Divider(color: Color(0xFF777777), thickness: 1.w),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // if (scannedCode != null) ...[
        //   SingleChildScrollView(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //
        //       Text(
        //         "Scanned: $scannedCode",
        //         style: const TextStyle(
        //           color: Colors.green,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       ElevatedButton(
        //         onPressed: () async {
        //           await _controller.start();
        //           setState(() => scannedCode = null);
        //         },
        //         child: const Text("Scan again"),
        //       ),
        //
        //
        //
        //
        //     ],),
        //   ),
        //
        // ],
        CustomCard(
          height: 52.h,
          width: 279.w,
          child: Center(
            child:  CustomText(text: "SWB-QR-9842736590",
              color: AppColors.buttonTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              language: false,
            ),




            // Text(
            //   "SWB-QR-9842736590",
            //   style: AppTextStyle.mediumStyle.copyWith(
            //     color: AppColors.buttonTextColor,
            //   ),
            // ),
          ),
        ),
        SizedBox(height: 16.h),
        ApplyWidget(onPressed: () {}),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
          .w // ✅ মোটা লাইন
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // ✅ লাইনের শেষ গোল হবে

    const double cornerLength = 35; // corner এর লম্বা

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
