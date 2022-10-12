import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_speed/callbacks_enum.dart';

import 'package:internet_speed/internet_speed.dart';
import 'package:speed_test_beta/controller/controllers.dart';
import 'package:dart_ping/dart_ping.dart';

import '../helpers/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Color.fromARGB(255, 118, 190, 214),
      const Color(0xfffd8204),
    ];
    RxDouble transferRateRx = 0.0.obs;
    RxDouble transferRateRxUpload = 0.0.obs;

    RxBool isTesting = false.obs;

    RxString speedUnitDownload = "".obs;
    RxString speedUnitUpload = "".obs;

    RxInt? pingINT = 0.obs;

    // var pingObject;

    final dataController = Get.put(SpeedTestController());

    return Scaffold(
      backgroundColor: Color(0xff103863),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Speed test page',
            style: GoogleFonts.poppins(fontSize: 30),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Obx(
                    () => Text(
                      'Download speed: $transferRateRx $speedUnitDownload',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Obx(
                    () => Text(
                      'Upload speed: $transferRateRxUpload $speedUnitUpload',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  //!download chart
                  height: 200,
                  child: Obx(
                    () {
                      return Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.9,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  color: Color.fromARGB(130, 35, 45, 55)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0,
                                    left: 12.0,
                                    top: 24,
                                    bottom: 12),
                                child: LineChart(
                                  LineChartData(
                                    maxX: dataController.downloadData.length
                                        .toDouble(),
                                    minX: 0,
                                    maxY:
                                        dataController.maxDownloadSpeed.value +
                                            15,
                                    minY: 0,
                                    gridData: gridData(),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: dataController
                                            .graphPointDataDownload,
                                        isCurved: true,
                                        gradient: LinearGradient(
                                          colors: gradientColors,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        barWidth: 5,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: false,
                                        ),
                                        show:
                                            dataController.showDownloadGraph(),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            colors: gradientColors
                                                .map((color) =>
                                                    color.withOpacity(0.3))
                                                .toList(),
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        axisNameWidget: const Text(
                                          "Packets",
                                          style: TextStyle(
                                            color: Color(0xff68737d),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          getTitlesWidget: leftTitleWidgets,
                                          reservedSize: 42,
                                        ),
                                      ),
                                    ),
                                    borderData: borderData(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  //! upload chart
                  height: 200,
                  child: Obx(
                    () {
                      return LineChart(
                        LineChartData(
                          maxX: dataController.uploadData.length.toDouble(),
                          minX: 0,
                          maxY: dataController.maxUploadSpeed.value + 0.3,
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: dataController.graphPointDataUpload,
                              isCurved: true,
                              show: dataController.showUploadGraph(),
                            ),
                          ],
                          titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                axisNameWidget: const Text(
                                  "Packets",
                                ),
                              ),
                              topTitles: AxisTitles(
                                axisNameWidget: const Text(""),
                              ),
                              rightTitles: AxisTitles(
                                axisNameWidget: const Text(""),
                              )),
                          borderData: borderData(),
                          gridData: gridData(),
                        ),
                      );
                    },
                  ),
                ),
                Obx(
                  () {
                    if (!isTesting.value) {
                      return ElevatedButton(
                        //! test Button download logic start
                        onPressed: () async {
                          isTesting.value = true; //?variable to enable button
                          dataController.emptyList();
                          final internetSpeed = InternetSpeed();

                          //TODO PING SERVER
                          internetSpeed.startDownloadTesting(
                            onDone: (double transferRate, SpeedUnit unit) {
                              // dataController.displaylist();
                              speedUnitUpload.value = unit.name;
                              //todo UPLOAD LOGIC
                              internetSpeed.startUploadTesting(
                                onDone: (double transferRate, SpeedUnit unit) {
                                  isTesting.value = false;
                                },
                                onProgress: (double percent,
                                    double transferRate, SpeedUnit unit) {
                                  transferRateRxUpload.value =
                                      transferRate.toInt()*10; //?Ui variable
                                  dataController.addTolistUpload(transferRate);
                                },
                                onError: (String errorMessage,
                                    String speedTestError) {
                                  print(errorMessage);
                                },
                              );
                            },
                            onProgress: (double percent, double transferRate,
                                SpeedUnit unit) {
                              speedUnitDownload.value = unit.name;
                              transferRateRx.value = transferRate;
                              dataController.addTolist(transferRate);
                            },
                            onError:
                                (String errorMessage, String speedTestError) {
                              print(errorMessage);
                            },
                          );
                        },
                        style: buttonstyle(isTesting),
                        child: testButtonChild("Test"),
                      );
                    } else {
                      return ElevatedButton(
                        //! Download Button
                        onPressed: null,
                        style: buttonstyle(isTesting),
                        child: testButtonChild("Testing"),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }





 

  
}
