import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lanla_flutter/pages/publish/view.dart';


class Publicmethodes extends GetxController {
 ///转圈
  Future<void> loades(context,text) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return
            LoadingDialog(text: text,);
          // Container();
        });
  }
  ///时间转换
  timeconversion(time) {
    final deviceTimeZone = DateTime.now().timeZoneOffset;
    // print('时间${DateTime.parse(time)}');
    // print('时区${deviceTimeZone}');
    // print('解析后时间${DateTime.parse(time).toLocal().add(deviceTimeZone)}');
    return DateTime.parse(time).toLocal().add(deviceTimeZone);
  }
}
