import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';

import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import 'state.dart';

class LikeandCollectLogic extends GetxController {
  final LikeandCollectState state = LikeandCollectState();
  final logictwo = Get.find<MessageLogic>();
  NewesProvider provider =  Get.put(NewesProvider());
  Future<void> ZanheCollection() async {
    var result = await provider.Messageinterface(2,1);
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    if(result.statusCode==200){
      state.zanandshou =MessageFromJson(result?.bodyString ?? "");
      logictwo.empty();
      print(state.zanandshou);
      state.oneData=true;
      update();
    }
  }
}
