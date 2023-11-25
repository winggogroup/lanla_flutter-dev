import 'dart:io';

import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
// app挂起的时间(时间戳)
int AppPausedTime = 0;
// 总共挂起的时间
int AppPausedTimeTotal = 0;

AppLog(
  action, {
  String event = '',
  String module = '',
  String data = '',
  int targetid = 0,
  int pagetime = 0,
  String scroll = '',
  String page = '',
  String backpage = '',
      String videoplaytime = '',
      String videoplayproportion = '',
}) async {
  print('serverlog');
  UserLogic user = Get.find<UserLogic>();
  user.userId;
  PackageInfo info = await PackageInfo.fromPlatform();
  print('挂起时间 $AppPausedTimeTotal');
  Map<String, String> uri = {
    "userid": user.userId.toString(),
    "token": user.token,
    "action": action,
    "event": event,
    "targetid": targetid.toString(),
    "data": data,
    "module": module,
    "name": info.appName,
    "build": info.buildNumber,
    "version": info.version,
    "brand": user.deviceData?['brand'] ?? "",
    "systemversion": user.deviceData?['systemVersion']??"-",
    "platform": user.deviceData?['Platform']??"-",
    //"isphysicaldevice": user.deviceData?['isPhysicalDevice'] ? 'y' : 'n',
    "uuid": user.deviceData?['uuid']??(uuid??"-"),
    "incremental": user.deviceData?['incremental']??"-",
    "pagetime": (pagetime - AppPausedTimeTotal < 0 ? 0 : pagetime - AppPausedTimeTotal).toString(),
    "scroll": scroll,
    "page": page,
    "backpage": backpage,
    "videoplaytime": videoplaytime,
    "videoplayproportion": videoplayproportion,
    "luuid":uuid??"-",
  };
  if(action == 'page'){
    AppPausedTime = 0;
    AppPausedTimeTotal = 0;
  }
  http.get(Uri(
      scheme: 'https',
      host: 'app.log.lanla.app',
      queryParameters: uri,
      path: '/'));
  print('日志');
  uri.remove('token');
  print(uri);
  print('log url：${Uri(scheme: 'https', host: 'app.log.lanla.app', queryParameters: uri, path: '/')}');
}
