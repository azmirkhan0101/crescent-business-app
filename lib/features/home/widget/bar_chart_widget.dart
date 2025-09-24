import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';

class HomeBarChartWidget extends StatelessWidget {
  const HomeBarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 343.h, // 🔹 Fixed card height
      child: Card(
        color: AppColors.white,
        shadowColor:Colors.grey.shade200,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Row with icon & title
              Row(
                children: [Image.asset(AssetsPath.dataTrendingIcon,height: AppSizes.iconS24H,width: AppSizes.iconS24W,),
                  SizedBox(width: 8.w),
                  Text(
                    'Bar Chart',
                    style: AppTextStyle.cardTextStyle
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // 🔹 Percentage + Subtitle
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '57%',
                    style: AppTextStyle.headlineLStyle.copyWith(fontSize: AppSizes.headlineXL),
                  ),
                  SizedBox(width: 12.w,),
                  Text(
                    'Total activity\nof dummy data',
                    style: AppTextStyle.mediumStyle.copyWith(fontSize: AppSizes.smallTSize),
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              // 🔹 Chart Area (fixed height 210.h)
              SizedBox(
                height: 210.h,
                child: BarChart(
                  BarChartData(
                    maxY: 60000,
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: getTitles,
                          reservedSize: 38,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: leftTitles,
                          reservedSize: 40,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 25000,
                            color: Color(0xFFFF6F61),
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
                            color: Color(0xFFFF6F61),
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
                            color: Color(0xFFFF6F61),
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
                            color: Color(0xFFFF6F61),
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
                            color: Color(0xFFFF6F61),
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
                            color: Color(0xFFFF6F61),
                            width: 11.43.w,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                            toY: 25000,
                            color: Color(0xFFFF6F61),
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

  // 🔹 Bottom Titles (X-Axis)
  static Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.blackTextColor,
      fontFamily: 'inter',
      fontWeight: FontWeight.w400,
      fontSize: 10
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
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      space: 8,
      meta: meta,
      child: text,
    );
  }

  // 🔹 Left Titles (Y-Axis)
  static Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: AppColors.blackTextColor,
        fontFamily: 'inter',
        fontWeight: FontWeight.w400,
        fontSize: 10
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10000) {
      text = '10K';
    } else if (value == 20000) {
      text = '20K';
    } else if (value == 30000) {
      text = '30K';
    } else if (value == 40000) {
      text = '40K';
    } else if (value == 50000) {
      text = '50K';
    } else {
      return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
