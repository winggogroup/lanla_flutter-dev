import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';

import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import 'state.dart';

class AommentLogic extends GetxController {
  final AommentState state = AommentState();
  NewesProvider provider =  Get.put(NewesProvider());
  Future<void> Aommentandai () async {
    var result = await provider.Messageinterface(5,1);
    if(result.statusCode==200){
      state.zanandai =MessageFromJson(result?.bodyString ?? "");
      print(state.zanandai);
      state.oneData=true;
      update();
    }
  }
}
