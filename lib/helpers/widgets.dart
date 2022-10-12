import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff67727d),
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '1mb';
      break;
    case 5:
      text = '5mb';
      break;
    case 10:
      text = '10mb';
      break;
    case 15:
      text = '15mb';
      break;
    case 20:
      text = '20mb';
      break;
    case 30:
      text = '30mb';
      break;
    case 40:
      text = '40mb';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;

  text = const Text('Packets', style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8.0,
    child: text,
  );
}

ButtonStyle buttonstyle(RxBool isTesting) {
  if (isTesting.value) {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all(Color.fromARGB(255, 157, 88, 18)),
        foregroundColor: MaterialStateProperty.all(
          Color.fromARGB(255, 176, 176, 176),
        ),
        enableFeedback: true);
  } else {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color(0xfffd8204),
        ),
        foregroundColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.9),
        ),
        enableFeedback: true);
  }
}

Padding testButtonChild(String textStr) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      textStr,
      style: const TextStyle(fontSize: 30),
    ),
  );
}

FlBorderData borderData() {
  return FlBorderData(
    show: true,
    border: Border.all(
      color: const Color(0xff37434d),
      width: 2,
    ),
  );
}

FlGridData gridData() {
  return FlGridData(
    show: true,
    drawVerticalLine: true,
    horizontalInterval: 4,
    verticalInterval: 4,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 1,
      );
    },
    getDrawingVerticalLine: (value) {
      return FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 1,
      );
    },
  );
}
