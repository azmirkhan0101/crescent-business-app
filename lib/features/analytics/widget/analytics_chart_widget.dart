import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsCardChart extends StatelessWidget {
  const AnalyticsCardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: SizedBox(
        height: 384.h,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Row (Image + Title)
              Row(
                children: [
                  Image.asset(AssetsPath.dataTrendingIcon, height: 24.h, width: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    "Analytics Overview",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // 🔹 Subtitle Text
              Text(
                "Select a reward:",
                style: AppTextStyle.mediumStyle.copyWith(
                  fontSize: 12.sp,
                  color: const Color(0xFF6E6E6E),
                ),
              ),

              SizedBox(height: 12.h),

              // container with drop down
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                height: 40.h,
                width: 311.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Text(
                      "10% Off Entire Order",
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackTextColor
                      ),

                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // 🔹 Row (3 items)
              Row(
                children: [
                  _buildStatItem(AssetsPath.radioButton, "240 Views"),
                  SizedBox(width: 8.w),
                  _buildStatItem(AssetsPath.radioButton1, "100 Claims"),
                  SizedBox(width: 8.w),
                  _buildStatItem(AssetsPath.radioButton2, "55 Redeems"),
                ],
              ),

              SizedBox(height: 12.h),

              // 🔹 Chart (200.h)
              // 🔹 Chart (200.h)
              SizedBox(
                height: 200.h,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    minimum: 0,
                    maximum: 7, // 0 + 23..29 = 8 points
                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLabelFormatter: (AxisLabelRenderDetails args) {
                      const labels = ["0", "23", "24", "25", "26", "27", "28", "29"];
                      int index = args.value.toInt();
                      if (index >= 0 && index < labels.length) {
                        return ChartAxisLabel(labels[index], null);
                      }
                      return ChartAxisLabel('', null);
                    },
                  ),



                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 250,
                    interval: 50,
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Colors.transparent, // sob grey line remove
                    ),
                    axisLine: const AxisLine(width: 0),
                    // 0 point er jonno special blue line
                    plotBands: <PlotBand>[
                      PlotBand(
                        start: 0,
                        end: 0,
                        borderColor: Colors.blue,
                        borderWidth: 5, // blue line thickness
                      ),
                    ],
                  ),











                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: const Legend(isVisible: true),
                  series: <CartesianSeries>[
                    /// Views Series (Green)
                    SplineSeries<ChartData, double>(
                      dataSource: [
                        ChartData(x: 0, count: 60),
                        ChartData(x: 1, count: 90),
                        ChartData(x: 2, count: 120),
                        ChartData(x: 3, count: 140),
                        ChartData(x: 4, count: 180),
                        ChartData(x: 5, count: 160),
                        ChartData(x: 6, count: 240),
                        ChartData(x: 7, count: 160),
                      ],
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.count,
                      color: Colors.green,
                      name: "Views",
                      splineType: SplineType.natural,
                    ),

                    /// Claims Series (Blue)
                    SplineSeries<ChartData, double>(
                      dataSource: [
                        ChartData(x: 0, count: 30),
                        ChartData(x: 1, count: 40),
                        ChartData(x: 2, count: 80),
                        ChartData(x: 3, count: 90),
                        ChartData(x: 4, count: 30),
                        ChartData(x: 5, count: 40),
                        ChartData(x: 6, count: 60),
                        ChartData(x: 7, count: 100),
                      ],
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.count,
                      color: Colors.blue,
                      name: "Claims",
                      splineType: SplineType.natural,
                    ),

                    /// Redeems Series (Purple)
                    SplineSeries<ChartData, double>(
                      dataSource: [
                        ChartData(x: 0, count: 0),
                        ChartData(x: 1, count: 30),
                        ChartData(x: 2, count: 50),
                        ChartData(x: 3, count: 40),
                        ChartData(x: 4, count: 10),
                        ChartData(x: 5, count: 30),
                        ChartData(x: 6, count: 50),
                        ChartData(x: 7, count: 60),
                      ],
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.count,
                      color: Colors.purple,
                      name: "Redeems",
                      splineType: SplineType.natural,
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

  Widget _buildStatItem(String assetPath, String text) {
    return Row(
      children: [
        Image.asset(assetPath, height: 20.h, width: 20.w),
        SizedBox(width: 2.w),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class ChartData {
  final double x; // numeric X value
  final double count; // Y value
  ChartData({required this.x, required this.count});
}
