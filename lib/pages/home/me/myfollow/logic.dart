import 'package:get/get.dart';

import '../../../../models/UsersAndUser.dart';
import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import 'state.dart';

class MyfollowLogic extends GetxController {
  final MyfollowState state = MyfollowState();
  NewesProvider provider =  Get.put(NewesProvider());
  Future<void> MyfollowList(userId) async {
    var result = await provider.Myfollowinterface(userId,state.page);
    if(result.statusCode==200){
      state.Myfollowlist =UserandUserFromJson(result?.bodyString ?? "");
      update();
    }
  }
}
