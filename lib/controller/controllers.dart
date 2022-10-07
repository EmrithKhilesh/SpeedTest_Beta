import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:internet_speed/internet_speed.dart';

class SpeedTestController extends GetxController {
  List<FlSpot> graphPointDataDownload = <FlSpot>[];
  List<FlSpot> graphPointDataUpload = <FlSpot>[];

  List<dynamic> downloadData = [].obs;
  List<dynamic> uploadData = [].obs;

  RxBool showUploadBool = false.obs;
  RxBool showdownloadBool = false.obs;

  bool showDownloadGraph() {
    if (graphPointDataDownload.isNotEmpty) {
      showdownloadBool.value = true;
      return showdownloadBool.value;
    } else {
      return showdownloadBool.value;
    }
  }

  bool showUploadGraph() {
    if (graphPointDataUpload.isNotEmpty) {
      showUploadBool.value = true;
      return showUploadBool.value;
    } else {
      return showUploadBool.value;
    }
  }

  void addTolist(double data) {
    downloadData.add(data.toInt());
    graphPointDataDownload.add(FlSpot(downloadData.length.toDouble() - 1, data));
  }

  void addTolistUpload(double data) {
    uploadData.add(data.toInt());
    graphPointDataUpload.add(FlSpot(uploadData.length.toDouble() - 1, data));
  }

  // void displaylist() {
  //   for (var element in downloadData) {
  //   }
  // }

  void emptyList() {
    downloadData.clear();
    uploadData.clear();
    graphPointDataDownload.clear();
    graphPointDataUpload.clear();
  }
}
