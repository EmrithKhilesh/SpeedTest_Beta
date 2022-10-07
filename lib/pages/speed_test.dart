import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_speed/callbacks_enum.dart';

import 'package:internet_speed/internet_speed.dart';
import 'package:speed_test_beta/controller/controllers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxDouble transferRateRx = 0.0.obs;
    RxDouble transferRateRxUpload = 0.0.obs;

    RxBool isTesting = false.obs;

    RxString speedUnit = "".obs;

    final dataController = Get.put(SpeedTestController());

    return Scaffold(
      appBar: AppBar(title: const Text('Speed test page')),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Obx(
                    () => Text(
                      'Download speed: $transferRateRx $speedUnit',
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
                      'Upload speed: $transferRateRxUpload $speedUnit',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (!isTesting.value) {
                      return ElevatedButton(
                        //! Download Button
                        onPressed: () {
                          isTesting.value = true; //?variable to enable button
                          dataController.emptyList();
                          final internetSpeed = InternetSpeed();

                          //todo DOWNLOAD LOGIC
                          var counter = 0;
                          internetSpeed.startDownloadTesting(
                            onDone: (double transferRate, SpeedUnit unit) {
                              // dataController.displaylist();
                              speedUnit.value = unit.name;
                              //todo UPLOAD LOGIC
                              internetSpeed.startUploadTesting(
                                onDone: (double transferRate, SpeedUnit unit) {
                                  isTesting.value = false;
                                },
                                onProgress: (double percent,
                                    double transferRate, SpeedUnit unit) {
                                  transferRateRxUpload.value =
                                      transferRate; //?Ui variable
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
                              counter = counter + 1;
                              transferRateRx.value = transferRate;
                              dataController.addTolist(transferRate);
                            },
                            onError:
                                (String errorMessage, String speedTestError) {
                                  print(errorMessage);

                                },
                          );
                        },
                        child: const Text("Test"),
                      );
                    } else {
                      return const ElevatedButton(
                        //! Download Button
                        onPressed: null,
                        child: Text("Test"),
                      );
                    }
                  },
                ),
                SizedBox(
                  //!download chart
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
                              spots: dataController.graphPointDataDownload,
                              isCurved: true,
                              show: dataController.showDownloadGraph(),
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
                            ),
                          ),
                        ),
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
                          maxY: 1,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
