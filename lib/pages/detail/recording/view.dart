import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class RecordingPage extends StatelessWidget {
  final logic = Get.put(RecordingLogic());
  final state = Get.find<RecordingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
