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

  RxDouble maxDownloadSpeed = 0.0.obs;
  RxDouble maxUploadSpeed = 0.0.obs;

  bool showDownloadGraph() {
    if (graphPointDataDownload.isNotEmpty) {
      return showdownloadBool.value = true;
    } else {
      return showdownloadBool.value = false;
    }
  }

  bool showUploadGraph() {
    if (graphPointDataUpload.isNotEmpty) {
      return showUploadBool.value = true;
    } else {
      return showUploadBool.value = false;
    }
  }

  void addTolist(double data) {
    downloadData.add(data.toInt());
    graphPointDataDownload
        .add(FlSpot(downloadData.length.toDouble() - 1, data));

    if (data > maxDownloadSpeed.value) {
      maxDownloadSpeed.value = data;
    }
  }

  void addTolistUpload(double data) {
    uploadData.add(data.toInt());
    
    graphPointDataUpload.add(FlSpot(uploadData.length.toDouble() - 1, data));
    if (data > maxUploadSpeed.value) {
      maxUploadSpeed.value = data;
    }
  }

  void emptyList() {
    downloadData.clear();
    uploadData.clear();
    graphPointDataDownload.clear();
    graphPointDataUpload.clear();
  }
}
