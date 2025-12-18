import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/data/models/analytics/graph_data_model.dart';
import 'package:organization/data/models/analytics/summary_model.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsCardChart<T> extends StatelessWidget {

  final List<String> items;
  final String selectedTitle;
  final Function(String) onItemSelected;
  final SummaryModel? summaryModel;
  final List<GraphDataModel> graphList;

  const AnalyticsCardChart({
    super.key,
    required this.items,
    required this.selectedTitle,
    required this.onItemSelected,
    required this.summaryModel,
    required this.graphList,
  });

  @override
  Widget build(BuildContext context) {

    final filteredStats = filterLatestData( graphList );
    final rawMax = getMaxValue(filteredStats);
    final maxY = roundToNiceNumber(rawMax);
    final interval = calculateInterval(maxY);

    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: SizedBox(
       // height: 400.h,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //DEGUG BUTTON TODO:
              ElevatedButton(onPressed: (){
                //=====================================================================
                print("Graphs: ${graphList}");
                print("Filtered: ${(filteredStats)}");
                print("Views: ${viewsDataSource(filteredStats)}");
              }, child: Text("Debug")),
              // 🔹 Top Row (Image + Title)
              Row(
                children: [
                  Image.asset(AssetsPath.dataTrendingIcon, height: 24.h, width: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    "Reward Performance",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomText(text: "Select a reward:",
              fontSize: 12.sp,
                color: const Color(0xFF6E6E6E),
                fontWeight: FontWeight.w400,
                language: false,
              ),
              SizedBox(height: 12.h),
              // container with drop down
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x199E9E9E),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedTitle,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackTextColor,
                                fontSize: 14.sp,
                              ),
                              onChanged: (String? newValue) {
                                if( newValue != null ){
                                  onItemSelected( newValue );
                                }
                              },
                              items:
                              items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8
                                      ),
                                      child: Text(value,
                                      maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // 🔹 Row (3 items)
              Row(
                children: [
                  _buildStatItem(AssetsPath.radioButton, "${summaryModel?.views ?? 0} Views"),
                  SizedBox(width: 8.w),
                  _buildStatItem(AssetsPath.radioButton1, "${summaryModel?.claims ?? 0} Claims"),
                  SizedBox(width: 8.w),
                  _buildStatItem(AssetsPath.radioButton2, "${summaryModel?.redemptions ?? 0} Redemptions"),
                ],
              ),

              SizedBox(height: 12.h),

              // 🔹 Chart (200.h)
              // 🔹 Chart (200.h)
              SizedBox(
                height: 210.h,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    minimum: 0,//COMPARE WITH CURRENT DATE
                    maximum: 9, //MAX 7 || 1
                    interval: 1,
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Colors.transparent,
                    ),
                    axisLabelFormatter: (AxisLabelRenderDetails args) {
                      //const labels = ["0", "23", "24", "25", "26", "27", "28", "29"];
                      final labels = dayLabels( filteredStats );
                      int index = args.value.toInt();
                      if (index >= 0 && index < labels.length) {
                        return ChartAxisLabel(labels[index], null);
                      }
                      return ChartAxisLabel('', null);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: maxY.toDouble(),
                    interval: interval,
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Colors.grey.shade100,
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
                      dataSource: viewsDataSource( filteredStats ),
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.count,
                      color: Colors.green,
                      name: "Views",
                      splineType: SplineType.natural,
                    ),

                    /// Claims Series (Blue)
                    SplineSeries<ChartData, double>(
                      dataSource: claimDataSource( filteredStats ),
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.count,
                      color: Colors.blue,
                      name: "Claims",
                      splineType: SplineType.natural,
                    ),
                    /// Redeems Series (Purple)
                    SplineSeries<ChartData, double>(
                      dataSource: redeemDataSource( filteredStats ),
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


  //Y AXIS MAX VALUE FROM API
  double getMaxValue(List<GraphDataModel> graphs) {
    if (graphs.isEmpty) return 0;

    double maxValue = 0;

    for (final graph in graphs) {
      maxValue = [
        maxValue,
        graph.views.toDouble(),
        graph.claims.toDouble(),
        graph.redemptions.toDouble(),
      ].reduce((a, b) => a > b ? a : b);
    }

    return maxValue;
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

  //FILTER LATEST SEVEN DAYS DATA
  List<GraphDataModel> filterLatestData(List<GraphDataModel> data) {

    if( data.isEmpty ) return data;//SKIP IF DATA IS EMPTY

    return data.length <=10
        ?
        data
        :
        data.sublist( data.length - 10 );

  }

  //DYNAMIC INTERVAL OF Y AXIS VALUES
  double calculateInterval(num maxY, {int steps = 5}) {
    if (maxY <= 0) return 1; //fallback interval is 1
    return (maxY / steps).ceilToDouble();
  }

  //FILTERED DAYS
List<String> dayLabels(List<GraphDataModel> graphs){

    List<String> days = [];
    if( graphs.isEmpty ){
      return days;
    }
    //GET DAYS FROM FILTERED LIST
    for( final model in graphs ){
      days.add( "${model.day}" );
    }
    return days;
}


//Views DATA SOURCE
  List<ChartData> viewsDataSource( List<GraphDataModel> filteredGraphs ){

    List<ChartData> viewsDataList = [];
    if( filteredGraphs.isEmpty ){
      return viewsDataList;
    }
    int x = 0;
    for( final model in filteredGraphs ){
      viewsDataList.add( ChartData( x: x.toDouble(), count: model.views.toDouble() ));
      x++;
    }
    return viewsDataList;
  }


//CLAIM DATA SOURCE
  List<ChartData> claimDataSource( List<GraphDataModel> filteredGraphs ){

    List<ChartData> claimDataList = [];
    if( filteredGraphs.isEmpty ){
      return claimDataList;
    }
    int x = 0;
    for( final model in filteredGraphs ){
      claimDataList.add( ChartData( x: x.toDouble(), count: model.claims.toDouble() ));
      x++;
    }
    return claimDataList;
  }


//REDEEM DATA SOURCE
List<ChartData> redeemDataSource( List<GraphDataModel> filteredGraphs ){

    List<ChartData> redeemDataList = [];
    if( filteredGraphs.isEmpty ){
      return redeemDataList;
    }
    int x = 0;
    for( final model in filteredGraphs ){
      redeemDataList.add( ChartData( x: x.toDouble(), count: model.redemptions.toDouble() ));
      x++;
    }
    return redeemDataList;
}


}

class ChartData {
  final double x; // numeric X value
  final double count; // Y value
  ChartData({required this.x, required this.count});
}
