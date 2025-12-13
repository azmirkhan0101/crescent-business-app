import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/data/models/monthly_stats.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';

class HomeBarChartWidget extends StatelessWidget {

  final List<MonthlyStats> stats;

  const HomeBarChartWidget({
    super.key,
    required this.stats
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 343.h,
      child: Card(
        color: AppColors.white,
        shadowColor: Colors.grey.shade200,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with icon & title
              Row(
                children: [
                  Image.asset(
                    AssetsPath.dataTrendingIcon,
                    height: AppSizes.iconS24H,
                    width: AppSizes.iconS24W,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Stats',
                    style: AppTextStyle.cardTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Percentage + Subtitle
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '57%',
                    style: AppTextStyle.headlineLStyle
                        .copyWith(fontSize: AppSizes.headlineXL),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomText(
                      text: "Total activity of monthly redemptions",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      language: false,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              // Chart Area
              SizedBox(
                height: 210.h,
                child: BarChart(
                  BarChartData(
                    maxY: 60000,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 25000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: 45000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 32000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: 52000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: 18000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                            toY: 39000,
                            color: const Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                    ],
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: 10000,
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
                          getTitlesWidget: getTitles,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 10000,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                      topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
  static Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.blackTextColor,
      fontFamily: 'inter',
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('Dec', style: style);
        break;
    }
    return SideTitleWidget(
      space: 8,
      meta: meta,
      child: text,
    );
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
}
