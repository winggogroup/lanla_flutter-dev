import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class FollowingAndFansPage extends StatelessWidget {
  final logic = Get.put(FollowingAndFansLogic());
  final state = Get.find<FollowingAndFansLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text('dsf')
    );
  }
}
