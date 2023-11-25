import 'package:get/get.dart';

import 'state.dart';

class Play_view_containerLogic extends GetxController {
  final Play_view_containerState state = Play_view_containerState();

  @override
  void onReady() {
    print('创建一个');
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print('资源没了');
    super.dispose();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    print('onClose');
    super.onClose();
  }
}
