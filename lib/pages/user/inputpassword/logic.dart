import 'dart:convert';

import 'package:get/get.dart';

import 'state.dart';
//接口管理的文件
import 'package:lanla_flutter/services/content.dart';
//跳转的页面
import '../set_information/view.dart';

class InputpasswordLogic extends GetxController {
  final InputpasswordState state = InputpasswordState();
  //实例化
  ContentProvider provider = Get.put(ContentProvider());

  SetPassword() async {
    // var result = await provider.SetPassword(Get.arguments["phone"], Get.arguments["area_code"],state.password);
    // print('请求接口');
    // print(result.statusCode);
    // print(result.bodyString);
    // Map<String, dynamic> responseData =  jsonDecode(result.bodyString.toString());
    // print(responseData);

    Get.to(SetInformationPage());
  }
}
