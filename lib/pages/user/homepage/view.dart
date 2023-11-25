import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class HomepagePage extends StatelessWidget {
  final logic = Get.put(HomepageLogic());
  final state = Get.find<HomepageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户页'),
      ),
    );
  }
}
