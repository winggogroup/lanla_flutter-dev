import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PracticePage extends StatelessWidget {
  final logic = Get.put(PracticeLogic());
  final state = Get.find<PracticeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
    );
  }
}
