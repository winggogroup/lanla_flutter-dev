import 'package:get/get.dart';

import 'logic.dart';

class PublishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublishLogic());
  }
}
