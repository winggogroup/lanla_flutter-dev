import 'package:get/get.dart';

import '../../../../models/UsersAndUser.dart';
import '../../../../services/newes.dart';
import 'state.dart';

class MyfansLogic extends GetxController {
  final MyfansState state = MyfansState();
  NewesProvider provider =  Get.put(NewesProvider());
  Future<void> Faninterface(userId) async {
    var result = await provider.Myfansinterface(userId,state.page);
    if(result.statusCode==200){
      state.Myfanslist =UserandUserFromJson(result?.bodyString ?? "");
      update();
    }
  }
}
