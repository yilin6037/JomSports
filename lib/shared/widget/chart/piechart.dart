import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SharedPieChart extends StatelessWidget {
  const SharedPieChart({super.key, required this.chartData});
  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <CircularSeries>[
      // Render pie chart
      PieSeries<ChartData, String>(
          name: 'hi',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.x,
                  softWrap: true,
                ),
                Text('\n(${data.y})')
              ],
            ),
          ),
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ]);
  }
}

class ChartData {
  ChartData(this.x, this.y, {this.color});
  String x;
  int y;
  Color? color;
}
