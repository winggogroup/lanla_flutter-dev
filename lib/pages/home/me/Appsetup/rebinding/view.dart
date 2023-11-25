import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class RebindingPage extends StatelessWidget {
  final logic = Get.put(RebindingLogic());
  final state = Get.find<RebindingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
