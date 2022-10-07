import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_test_beta/pages/line_chart.dart';

import '../controller/controllers.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataController = Get.put(SpeedTestController());

    return Scaffold(
      appBar: AppBar(title: Text('ChartPage')),
      body: Container(
        height: 200,
        child: Obx(
          () {
            return LineChart(
              LineChartData(
                maxX: dataController.downloadData.length.toDouble(),
                minX: 0,
                maxY: 10,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 2),
                      FlSpot(2, 1),
                      FlSpot(3, 5),
                      FlSpot(4, 3),
                    ],
                    isCurved: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
