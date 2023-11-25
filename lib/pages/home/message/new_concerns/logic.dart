import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';

import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import 'state.dart';

class NewConcernsLogic extends GetxController {
  final NewConcernsState state = NewConcernsState();
  NewesProvider provider =  Get.put(NewesProvider());
  Future<void> NewConcerns() async {
    var result = await provider.Messageinterface(4,1);
    if(result.statusCode==200){
      state.Newconcernslist =MessageFromJson(result?.bodyString ?? "");
      state.oneData=true;
      update();
    }
  }
}
