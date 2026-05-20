import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/data/models/home/monthly_stats.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../../utils/app_color.dart';

class HomeBarChartWidget extends StatelessWidget {

  final List<MonthlyStats> stats;
  final num activityPercentage;
  final bool isTab;

  const HomeBarChartWidget({
    super.key,
    required this.stats,
    required this.activityPercentage, required this.isTab
  });

  @override
  Widget build(BuildContext context) {

    String percentageText =
    activityPercentage % 1 == 0
        ? activityPercentage.toInt().toString()
        : activityPercentage.toString();

    final filteredStats = filterMonthlyStats(stats);
    final rawMax = getMaxValue(filteredStats);
    final maxY = roundToNiceNumber(rawMax);
    final interval = calculateInterval(maxY);

    return SizedBox(
      height: isTab ? 550 : 343.h,
      child: Card(
        color: AppColors.white,
        shadowColor: Colors.grey.shade200,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all( isTab ? 20 : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with icon & title
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.stats,
                    height: isTab ? 50 : AppSizes.iconS24H,
                    width: isTab ? 50 : AppSizes.iconS24W,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Bar Chart',
                    style: AppTextStyle.cardTextStyle.copyWith(fontSize: isTab ? 12.sp : null),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Percentage + Subtitle
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$percentageText %",
                    style: AppTextStyle.headlineLStyle
                        .copyWith(fontSize: isTab ? 16.sp : AppSizes.headlineXL),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomText(
                      maxLines: 2,
                      text: "Total activity of monthly redemptions",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      language: false,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              // Chart Area
              SizedBox(
                height: isTab ? 320 : 210.h,
                child: BarChart(
                  BarChartData(
                    maxY: maxY.toDouble(),
                    barGroups: buildBarGroups( filteredStats, isTab),
                    barTouchData: BarTouchData(
                      enabled: filteredStats.isNotEmpty,
                    ),
                    //DYNAMIC BARS
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade200,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 38,
                          getTitlesWidget: (value, meta){
                            return getTitles(value, meta, filteredStats, isTab);
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: interval,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(0)}k'
                                  : value.toInt().toString(),
                              style: TextStyle(fontSize: isTab ? 10.sp : 12.sp),
                            );
                          },
                        ),
                      ),
                      topTitles:
                      const AxisTitles(
                          sideTitles: SideTitles(showTitles: false,)),
                      rightTitles:
                      const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0,
                          color: Colors.red.shade100,
                          strokeWidth: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Titles (X-axis)
  static Widget getTitles(
      double value,
      TitleMeta meta,
      List<MonthlyStats> stats,
      bool isTab
      ) {
    final style = TextStyle(
      color: AppColors.blackTextColor,
      fontFamily: 'inter',
      fontWeight: FontWeight.w400,
      fontSize: isTab ? 8.sp : 10,
    );

    int index = value.toInt();

    if (index < 0 || index >= stats.length) {
      return const SizedBox.shrink();
    }

    // Example API month: "JAN", "FEB"
    final String month = stats[index].month;

    return SideTitleWidget(
      space: 8,
      meta: meta,
      child: Text(
        month.substring(0, 3), // JAN → Jan
        style: style,
      ),
    );
  }


  //Y AXIS MAX VALUE FROM API
  double getMaxValue(List<MonthlyStats> stats) {
    if (stats.isEmpty) return 0;

    return stats
        .map((e) => e.reward)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
  }

  //ROUND MAX VALUE TO NEAREST 10 POWER
  num roundToNiceNumber(double value) {
    if (value < 5) return 5;//MAX VALUE IS AT LEAST 5

    final magnitude = pow(10, (log(value) / ln10).floor());
    final normalized = value / magnitude;

    if (normalized <= 1) return 1 * magnitude;
    if (normalized <= 2) return 2 * magnitude;
    if (normalized <= 5) return 5 * magnitude;
    return 10 * magnitude;
  }

  //DYNAMIC INTERVAL OF Y AXIS VALUES
  double calculateInterval(num maxY, {int steps = 5}) {
    if (maxY <= 0) return 1; //fallback interval is 1
    return (maxY / steps).ceilToDouble();
  }





  // Left Titles (Y-axis)
  static Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.blackTextColor,
      fontFamily: 'inter',
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 10000:
        text = '10K';
        break;
      case 20000:
        text = '20K';
        break;
      case 30000:
        text = '30K';
        break;
      case 40000:
        text = '40K';
        break;
      case 50000:
        text = '50K';
        break;
      case 60000:
        text = '60K';
        break;
      default:
        text = '';
        break;
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  //DYNAMIC BARCHART GROUP
  List<BarChartGroupData> buildBarGroups(List<MonthlyStats> stats, bool isTab) {
    return List.generate(stats.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stats[index].reward.toDouble(),
            color: const Color(0xFFFF6F61),
            width: isTab ? 40 : 11.43.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      );
    });
  }

  //FILTER LATEST SIX MONTH DATA
  List<MonthlyStats> filterMonthlyStats(List<MonthlyStats> data) {

    if( data.isEmpty ) return data;//SKIP IF DATA IS EMPTY

    final int currentMonthIndex = DateTime.now().month - 1; //0-11

    int startIndex = currentMonthIndex > 5 ? currentMonthIndex - 5 : 0;

    int endIndex = currentMonthIndex + 1;

    return data.sublist( startIndex, endIndex );

  }


}
