import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/detail/video/logic.dart';

import 'logic.dart';

class PlayViewContainerPage extends StatelessWidget {
  final logic = Get.put(Play_view_containerLogic());
  final state = Get.find<Play_view_containerLogic>().state;
  final video_logic = Get.put(VideoLogic());

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('${video_logic.state.nowViewPage}',style: TextStyle(color: Colors.white),),),);
  }
}
