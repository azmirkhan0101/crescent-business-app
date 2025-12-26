import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/data/models/analytics/redemption_method_model.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import 'package:organization/utils/assets_path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RedemptionChartWidget extends StatelessWidget {

  final int? totalRedemptions;
  final List<RedemptionMethodModel>? methods;

  const RedemptionChartWidget({
    super.key,
    required this.totalRedemptions,
    required this.methods
  });

  @override
  Widget build(BuildContext context) {

    Color qrChartColor = Color(0xFFC4E862);
    Color nfcChartColor = Color(0xFFC0A4E8);
    Color codeChartColor = Color(0xFFFF7BD7);

    int qrCount = 0;
    int nfcCount = 0;
    int codeCount = 0;

    if( methods != null && methods!.length == 3 ){
      qrCount = methods![0].count;
      nfcCount = methods![1].count;
      codeCount = methods![2].count;
    }

    final List<ChartData> redemptionData = [
      ChartData('QR', qrCount, qrChartColor ),
      ChartData('NFC', nfcCount, nfcChartColor ),
      ChartData('Code', codeCount, codeChartColor ),
    ];

    bool hasData = redemptionData.any((e) => e.y > 0);

    final List<ChartData> chartSource = hasData
        ? redemptionData
        : [
      ChartData(
        'No Data',
        1,                     // must be > 0
        Colors.grey.shade300,  // grey color
      ),
    ];


    return SizedBox(
      height: 174.h,
      child: Card(
        color: AppColors.white,
        margin: EdgeInsets.all(12.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              //Left side texts
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icons.scanQrCode,
                          height: AppSizes.iconS24H,
                          width: AppSizes.iconS24W,
                          colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: CustomText(
                            text: "Total Redemptions",
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      "${totalRedemptions ?? 0}",
                      style: AppTextStyle.headlineLStyle.copyWith(
                        fontSize: AppSizes.headlineXL,
                      ),
                    ),
                    SizedBox(width: 6.h),
                    Row(
                      children: [
                        _buildLegendRow('QR', "$qrCount", qrChartColor ),
                        SizedBox(width: 18.w),
                        _buildLegendRow('NFC', "$nfcCount", nfcChartColor ),
                        SizedBox(width: 18.w),
                        _buildLegendRow('Code', "$codeCount", codeChartColor ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Right side chart
              SizedBox(
                height: 120.w,
                width: 120.w,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartSource,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      pointColorMapper: (ChartData data, _) => data.color,
                      innerRadius: '70%',
                      startAngle: 270,
                      endAngle: 270,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Legend builder
  Widget _buildLegendRow(String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 5.w),
          Column(
            children: [

              CustomText(text: title,
              fontSize: 12.sp,
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
                language: false,
              ),

              // Text(
              //   title,
              //   style: AppTextStyle.mediumStyle.copyWith(
              //     fontSize: AppSizes.smallTSize,
              //   ),
              // ),
              //

              CustomText(text: value,
                fontSize: 12.sp,
                color: AppColors.blackTextColor,
                fontWeight: FontWeight.w600,
                language: false,
              ),

              // Text(
              //   value,
              //   style: AppTextStyle.mediumStyle.copyWith(
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.blackTextColor,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final num y;
  final Color color;
}
